use std::fs;
use std::time::Duration;
use std::thread::sleep;

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[rustler::nif]
fn read_file(path: String) -> String {
    let data = fs::read_to_string(path.clone()).expect("Unable to read file");
    println!("------------------READ COMPLETED FROM RUST----------------------");
    let converted_string = data.to_lowercase();
    sleep(Duration::from_millis(30000));
    let capitalize = uppercase_first(converted_string);
    let final_string = format!("{}{}", capitalize, "...");
    // let final_string = format!("{}{}", converted_string, ".");
    return final_string;
}

fn uppercase_first(data: String) -> String {
    // Uppercase first letter.
    let mut result = String::new();
    let mut first = true;
    for value in data.chars() {
        if first {
            result.push(value.to_ascii_uppercase());
            first = false;
        } else {
            result.push(value);
        }
    }
    result
}

rustler::init!("Elixir.PhoenixDistillery.NifDemo");

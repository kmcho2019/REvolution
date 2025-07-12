module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Combine all inputs into a 3-bit vector
    wire [2:0] input_bus = {a, b, c};
    
    // Route signals using bit selection
    assign w = input_bus[2];  // a
    assign x = input_bus[1];  // b
    assign y = input_bus[1];  // b
    assign z = input_bus[0];  // c
endmodule
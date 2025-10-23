module TopModule (
    input  a,    // Input signal a
    input  b,    // Input signal b (connects to both x and y)
    input  c,    // Input signal c
    output w,    // Output w connected to a
    output x,    // Output x connected to b
    output y,    // Output y connected to b
    output z     // Output z connected to c
);
    // Direct wire connections
    assign w = a;
    assign x = b;
    assign y = b;  // b drives both x and y
    assign z = c;
endmodule
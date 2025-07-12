module TopModule (
    input  a,    // Input signal a
    input  b,    // Input signal b
    input  c,    // Input signal c
    output w,    // Output w connected to a
    output x,    // Output x connected to b
    output y,    // Output y connected to b
    output z     // Output z connected to c
);
    // Individual assignments for each connection
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;
endmodule
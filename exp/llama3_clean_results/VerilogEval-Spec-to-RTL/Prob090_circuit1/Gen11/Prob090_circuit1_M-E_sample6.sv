module TopModule(
    input  a,
    input  b,
    output q
);
    
    // Using a 2-to-1 MUX to achieve AND functionality
    // When a is 0, q is always 0, and when a is 1, q is b
    assign q = (a) ? b : 0;

endmodule
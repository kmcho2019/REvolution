module TopModule(
    input  wire a,    // First input
    input  wire b,    // Second input
    output wire out   // AND output
);
    // Continuous assignment for 2-input AND function
    assign out = a & b;
endmodule
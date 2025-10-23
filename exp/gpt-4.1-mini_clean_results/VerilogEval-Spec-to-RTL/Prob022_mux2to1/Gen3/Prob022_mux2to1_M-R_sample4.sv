module TopModule (
    input  wire a,    // Input bit a
    input  wire b,    // Input bit b
    input  wire sel,  // Select signal
    output wire out   // Output bit (wire type for continuous assignment)
);

assign out = sel ? b : a;

endmodule
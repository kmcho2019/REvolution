module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single vectorized conditional operator for entire 100-bit mux
    assign out = sel ? b : a;
endmodule
module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Vectorized 2-to-1 mux across the entire 100-bit width in a single line
    assign out = sel ? b : a;
endmodule
module BitMux2to1(
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);
    assign out = sel ? b : a;
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Vectorized 2-to-1 mux: synthesis-friendly and area/power optimized
    assign out = sel ? b : a;
endmodule
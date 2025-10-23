module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single vectorized 2-to-1 mux for the entire 100-bit vector
    assign out = sel ? b : a;
endmodule
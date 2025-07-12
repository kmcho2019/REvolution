module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Direct vectorized 2-to-1 mux for 100-bit bus
    assign out = sel ? b : a;

endmodule
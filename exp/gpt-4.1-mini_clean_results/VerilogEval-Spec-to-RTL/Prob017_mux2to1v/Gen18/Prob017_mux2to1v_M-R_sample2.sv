module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single-level vectorized 2-to-1 multiplexer selecting between a and b
    assign out = sel ? b : a;
endmodule
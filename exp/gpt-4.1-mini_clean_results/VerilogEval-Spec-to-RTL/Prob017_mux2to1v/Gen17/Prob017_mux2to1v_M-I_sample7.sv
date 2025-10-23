module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single 100-bit 2-to-1 multiplexer using ternary operator
    assign out = sel ? b : a;
endmodule
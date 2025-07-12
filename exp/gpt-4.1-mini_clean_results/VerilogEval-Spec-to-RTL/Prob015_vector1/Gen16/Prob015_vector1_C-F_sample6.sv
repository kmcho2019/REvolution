module ByteSplitter #(
    parameter WIDTH = 16,
    parameter HALF  = WIDTH / 2
) (
    input  wire [WIDTH-1:0] in,
    output wire [HALF-1:0]  out_hi,
    output wire [HALF-1:0]  out_lo
);
    // Combinational slicing: upper half and lower half bytes from input word
    assign out_hi = in[WIDTH-1:HALF];
    assign out_lo = in[HALF-1:0];
endmodule

module TopModule (
    input  wire [15:0] in,
    output wire [7:0]  out_hi,
    output wire [7:0]  out_lo
);
    // Instantiate parameterized ByteSplitter with default 16-bit width and 8-bit halves
    ByteSplitter splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule
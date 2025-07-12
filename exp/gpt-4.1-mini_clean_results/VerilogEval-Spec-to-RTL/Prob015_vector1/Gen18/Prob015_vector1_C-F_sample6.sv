module ByteSplitter #(
    parameter WIDTH = 16
) (
    input  [WIDTH-1:0]      in,
    output [(WIDTH/2)-1:0]  out_hi,
    output [(WIDTH/2)-1:0]  out_lo
);
    // Define local parameter HALF internally for clarity and ease of modification
    localparam HALF = WIDTH / 2;

    // Combinational slicing: upper and lower halves of input vector
    assign out_hi = in[WIDTH-1:HALF];
    assign out_lo = in[HALF-1:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Instantiate ByteSplitter with fixed WIDTH=16 for required splitting
    ByteSplitter #(
        .WIDTH(16)
    ) splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule
module TopModule #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 32
) (
    input [IN_WIDTH-1:0] in,
    output [OUT_WIDTH-1:0] out
);
    localparam EXTEND_BITS = OUT_WIDTH - IN_WIDTH;
    assign out = {{EXTEND_BITS{in[IN_WIDTH-1]}}, in};
endmodule
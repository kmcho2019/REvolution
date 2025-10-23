module TopModule #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 32
) (
    input  [IN_WIDTH-1:0] in,
    output [OUT_WIDTH-1:0] out
);
    assign out = { {(OUT_WIDTH-IN_WIDTH){in[IN_WIDTH-1]}}, in };
endmodule
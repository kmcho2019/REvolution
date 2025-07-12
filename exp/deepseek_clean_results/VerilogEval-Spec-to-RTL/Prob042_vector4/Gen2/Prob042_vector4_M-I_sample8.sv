module TopModule #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input  [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);
    localparam EXTENSION_BITS = OUTPUT_WIDTH - INPUT_WIDTH;
    assign out = {{EXTENSION_BITS{in[INPUT_WIDTH-1]}}, in};
endmodule
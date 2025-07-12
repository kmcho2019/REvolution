module TopModule #(
    parameter INPUT_WIDTH = 1,
    parameter OUTPUT_WIDTH = 1
)(
    input  [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);
    assign out = in;
endmodule
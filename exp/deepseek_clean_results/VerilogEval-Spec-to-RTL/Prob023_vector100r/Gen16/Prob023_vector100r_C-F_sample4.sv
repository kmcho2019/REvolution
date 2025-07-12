module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : bit_reversal
        localparam REVERSE_IDX = WIDTH-1-i;
        assign out[i] = in[REVERSE_IDX];
    end
endgenerate

endmodule
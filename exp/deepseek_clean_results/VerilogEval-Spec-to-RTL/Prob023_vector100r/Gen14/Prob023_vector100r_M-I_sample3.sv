module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

localparam LAST_IDX = WIDTH-1;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
        assign out[i] = in[LAST_IDX-i];
    end
endgenerate

endmodule
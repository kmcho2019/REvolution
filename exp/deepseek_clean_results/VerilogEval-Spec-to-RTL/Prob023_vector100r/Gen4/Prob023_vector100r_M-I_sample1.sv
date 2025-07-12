module TopModule (
    input  [99:0] in,
    output [99:0] out
);

localparam WIDTH = 100;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
        assign out[i] = in[WIDTH-1-i];
    end
endgenerate

endmodule
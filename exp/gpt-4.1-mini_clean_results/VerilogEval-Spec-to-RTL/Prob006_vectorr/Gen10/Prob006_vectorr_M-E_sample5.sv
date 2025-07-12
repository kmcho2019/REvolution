module TopModule(
    input  [7:0] in,
    output [7:0] out
);

genvar i;
wire [7:0] rev_bits;

generate
    for (i = 0; i < 8; i = i + 1) begin : bit_reverse_loop
        assign rev_bits[i] = in[7 - i];
    end
endgenerate

assign out = rev_bits;

endmodule
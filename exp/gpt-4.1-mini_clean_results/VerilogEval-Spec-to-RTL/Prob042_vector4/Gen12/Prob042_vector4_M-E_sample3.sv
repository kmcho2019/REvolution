module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    wire [23:0] upper_bits;

    genvar i;
    generate
        for (i = 0; i < 24; i = i + 1) begin : replicate_sign_bit
            assign upper_bits[i] = in[7];
        end
    endgenerate

    assign out = {upper_bits, in};

endmodule
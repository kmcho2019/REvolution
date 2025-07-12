module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    wire sign_bit = in[7];
    wire [23:0] replicated_sign;

    genvar i;
    generate
        for (i = 0; i < 24; i = i + 1) begin : replicate_sign_bit
            assign replicated_sign[i] = sign_bit;
        end
    endgenerate

    assign out = {replicated_sign, in};

endmodule
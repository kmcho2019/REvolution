module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    wire sign_bit;
    wire [23:0] sign_extension;

    assign sign_bit = in[7];

    genvar i;
    generate
        for (i = 0; i < 24; i = i + 1) begin : replicate_sign_bit
            assign sign_extension[i] = sign_bit;
        end
    endgenerate

    assign out = {sign_extension, in};

endmodule
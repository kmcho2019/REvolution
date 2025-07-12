module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    wire [23:0] replicated_sign_bits;

    genvar i;
    generate
        for (i = 0; i < 24; i = i + 1) begin : replicate_loop
            assign replicated_sign_bits[i] = in[7];
        end
    endgenerate

    assign out = {replicated_sign_bits, in};

endmodule
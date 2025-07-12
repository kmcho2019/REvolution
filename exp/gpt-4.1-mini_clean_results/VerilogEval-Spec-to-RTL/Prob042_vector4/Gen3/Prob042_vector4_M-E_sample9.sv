module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    genvar i;
    generate
        for (i = 0; i < 24; i = i + 1) begin : sign_bits
            assign out[31 - i] = in[7];  // replicate sign bit for upper 24 bits
        end
        for (i = 0; i < 8; i = i + 1) begin : data_bits
            assign out[i] = in[i];       // lower 8 bits are input bits
        end
    endgenerate

endmodule
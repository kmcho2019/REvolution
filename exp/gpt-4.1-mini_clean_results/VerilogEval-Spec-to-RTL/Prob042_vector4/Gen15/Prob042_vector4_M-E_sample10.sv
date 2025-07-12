module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    assign out[7:0] = in;

    genvar i;
    generate
        for (i = 8; i < 32; i = i + 1) begin : sign_extend_bits
            assign out[i] = in[7];
        end
    endgenerate

endmodule
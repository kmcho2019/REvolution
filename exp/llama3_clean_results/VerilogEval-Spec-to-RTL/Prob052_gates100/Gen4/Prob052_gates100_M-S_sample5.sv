module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [24:0] and_group;
    wire [24:0] or_group;
    wire [24:0] xor_group;

    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin
            assign and_group[i] = in[i*4] & in[i*4+1] & in[i*4+2] & in[i*4+3];
            assign or_group[i] = in[i*4] | in[i*4+1] | in[i*4+2] | in[i*4+3];
            assign xor_group[i] = in[i*4] ^ in[i*4+1] ^ in[i*4+2] ^ in[i*4+3];
        end
    endgenerate

    assign out_and = and_group[0];
    assign out_or = or_group[0];
    assign out_xor = xor_group[0];

    genvar j;
    generate
        for (j = 1; j < 25; j = j + 1) begin
            assign out_and = out_and & and_group[j];
            assign out_or = out_or | or_group[j];
            assign out_xor = out_xor ^ xor_group[j];
        end
    endgenerate

endmodule
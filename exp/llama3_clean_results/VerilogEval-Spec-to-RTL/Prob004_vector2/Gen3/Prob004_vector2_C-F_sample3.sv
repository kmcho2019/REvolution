module TopModule(
    input  wire [31:0] in,
    output wire [31:0] out
);

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin
            assign out[i*8 +: 8] = in[(3-i)*8 +: 8];
        end
    endgenerate

endmodule
module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign out[(i*8)+:8] = in[(3-i)*8 +: 8];  // Reversing byte order using generate block
        end
    endgenerate

endmodule
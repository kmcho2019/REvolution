module TopModule (
    input  [7:0] in,
    output       parity
);
    wire xor01, xor23, xor45, xor67;
    wire xor0123, xor4567;

    assign xor01   = in[0] ^ in[1];
    assign xor23   = in[2] ^ in[3];
    assign xor45   = in[4] ^ in[5];
    assign xor67   = in[6] ^ in[7];

    assign xor0123 = xor01 ^ xor23;
    assign xor4567 = xor45 ^ xor67;

    assign parity = xor0123 ^ xor4567;
endmodule
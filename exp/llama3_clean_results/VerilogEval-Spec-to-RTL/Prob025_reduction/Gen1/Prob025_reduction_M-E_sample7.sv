module TopModule(
    input [7:0] in,
    output parity
);

    wire p1, p2, p3, p4;

    // Calculate parity for each 2-bit segment
    assign p1 = in[1] ^ in[0];
    assign p2 = in[3] ^ in[2];
    assign p3 = in[5] ^ in[4];
    assign p4 = in[7] ^ in[6];

    // Combine parities to get final result
    assign parity = p1 ^ p2 ^ p3 ^ p4;

endmodule
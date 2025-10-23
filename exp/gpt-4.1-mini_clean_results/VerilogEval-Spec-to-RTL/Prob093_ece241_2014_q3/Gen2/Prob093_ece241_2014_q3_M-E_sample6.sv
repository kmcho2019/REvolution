module TopModule(
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);

    // K-map columns as functions of c,d for ab=00,01,11,10:
    // For notation, cd=00 means c=0,d=0 etc.
    // Values from the problem:
    // ab=00 -> mux_in[0]: cd=00:0, 01:1, 11:1, 10:1
    // ab=01 -> mux_in[1]: all zeros
    // ab=11 -> mux_in[2]: cd=00:0, 01:0, 11:1, 10:0
    // ab=10 -> mux_in[3]: cd=00:1, 01:0, 11:1, 10:1

    // Implement general 2-level 2-to-1 mux decomposition: 
    // f = d ? (c ? val_11 : val_01) : (c ? val_10 : val_00);

    // mux_in[0]:
    // val_00=0, val_01=1, val_11=1, val_10=1
    assign mux_in[0] = d ? (c ? 1'b1 : 1'b1) : (c ? 1'b1 : 1'b0);

    // mux_in[1]: all zero
    assign mux_in[1] = 1'b0;

    // mux_in[2]:
    // val_00=0, val_01=0, val_11=1, val_10=0
    assign mux_in[2] = d ? (c ? 1'b1 : 1'b0) : (c ? 1'b0 : 1'b0);

    // mux_in[3]:
    // val_00=1, val_01=0, val_11=1, val_10=1
    assign mux_in[3] = d ? (c ? 1'b1 : 1'b0) : (c ? 1'b1 : 1'b1);

endmodule
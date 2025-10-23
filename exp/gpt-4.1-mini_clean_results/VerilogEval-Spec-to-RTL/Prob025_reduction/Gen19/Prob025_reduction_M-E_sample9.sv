module TopModule(
    input  [7:0] in,
    output       parity
);
    wire p1, p2, p3, p4, p5, p6, p7;

    assign p1 = in[0] ^ in[1];
    assign p2 = p1    ^ in[2];
    assign p3 = p2    ^ in[3];
    assign p4 = p3    ^ in[4];
    assign p5 = p4    ^ in[5];
    assign p6 = p5    ^ in[6];
    assign p7 = p6    ^ in[7];

    assign parity = p7;
endmodule
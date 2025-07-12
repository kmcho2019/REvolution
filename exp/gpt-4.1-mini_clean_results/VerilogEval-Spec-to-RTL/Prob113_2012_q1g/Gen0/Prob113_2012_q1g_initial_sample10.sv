module TopModule(
    input [3:0] x,
    output f
);
    // x = {x[3], x[2], x[1], x[0]}
    // Minterms where f=1 based on the K-map:
    // Row 00 (x[3:2]=00): columns 00 and 10 -> x=0000 and 0010 = 0 and 2
    // Row 01 (01): all 0
    // Row 11 (11): columns 00, 01, 11 -> x=1100, 1101, 1111 = 12,13,15
    // Row 10 (10): columns 00, 01, 10 -> x=1000, 1001, 1010 = 8, 9, 10
    //
    // So f = 1 for x in {0, 2, 8, 9, 10, 12, 13, 15}

    assign f = (x == 4'd0)  ||
               (x == 4'd2)  ||
               (x == 4'd8)  ||
               (x == 4'd9)  ||
               (x == 4'd10) ||
               (x == 4'd12) ||
               (x == 4'd13) ||
               (x == 4'd15);

endmodule
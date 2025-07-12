module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    wire [3:0] in = {a,b,c,d};

    // out_sop = 1 for decimal 2,7,15
    // 2  = 4'b0010
    // 7  = 4'b0111
    // 15 = 4'b1111
    assign out_sop = (in == 4'd2) | (in == 4'd7) | (in == 4'd15);

    // out_pos = 0 for decimal 0,1,4,5,6,9,10,13,14
    // So out_pos = 1 except these inputs, minimal POS includes these maxterms:
    // Implement product-of-sums by excluding 3,8,11,12 (never occur) and the ones where output=1
    assign out_pos = (in != 4'd0) & (in != 4'd1) & (in != 4'd4) & (in != 4'd5) &
                     (in != 4'd6) & (in != 4'd9) & (in != 4'd10) & (in != 4'd13) & (in != 4'd14);

endmodule
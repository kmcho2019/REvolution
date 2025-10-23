module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [3:0] in_val = {a, b, c, d};

    // Detect if in_val is 2,7, or 15
    assign out_sop = (in_val == 4'd2)  // 0010
                   | (in_val == 4'd7)  // 0111
                   | (in_val == 4'd15); // 1111

    // Detect if in_val is in {0,1,4,5,6,9,10,13,14}
    assign out_pos = (in_val == 4'd0) 
                   | (in_val == 4'd1)
                   | (in_val == 4'd4)
                   | (in_val == 4'd5)
                   | (in_val == 4'd6)
                   | (in_val == 4'd9)
                   | (in_val == 4'd10)
                   | (in_val == 4'd13)
                   | (in_val == 4'd14);

endmodule
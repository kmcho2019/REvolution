module TopModule(
    input  [3:0] x,
    output       f
);

// List of minterms where f=1: 0,2,8,9,10,12,13,15
assign f = (x == 4'd0)  ||
           (x == 4'd2)  ||
           (x == 4'd8)  ||
           (x == 4'd9)  ||
           (x == 4'd10) ||
           (x == 4'd12) ||
           (x == 4'd13) ||
           (x == 4'd15);

endmodule
module TopModule(
    input  [3:0] x,
    output       f
);

    wire f_00, f_01, f_11, f_10;

    // LUT for x[2] = 0, x[3] = 0
    assign f_00 = (x[0] == 1'b0 && x[1] == 1'b0) || (x[0] == 1'b1 && x[1] == 1'b0);

    // LUT for x[2] = 0, x[3] = 1
    assign f_01 = 1'b0;

    // LUT for x[2] = 1, x[3] = 1
    assign f_11 = (x[0] == 1'b0 && x[1] == 1'b0) || (x[0] == 1'b0 && x[1] == 1'b1) || (x[0] == 1'b1 && x[1] == 1'b1);

    // LUT for x[2] = 1, x[3] = 0
    assign f_10 = (x[0] == 1'b0 && x[1] == 1'b0) || (x[0] == 1'b0 && x[1] == 1'b1) || (x[0] == 1'b1 && x[1] == 1'b0);

    // Select the correct LUT based on x[2] and x[3]
    assign f = (x[2] == 1'b0 && x[3] == 1'b0) ? f_00 :
               (x[2] == 1'b0 && x[3] == 1'b1) ? f_01 :
               (x[2] == 1'b1 && x[3] == 1'b1) ? f_11 :
               (x[2] == 1'b1 && x[3] == 1'b0) ? f_10 : 1'bx;

endmodule
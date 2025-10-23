module TopModule(
    input [3:0] x,  // x[3],x[2],x[1],x[0] (x[3:2] are row, x[1:0] are column)
    output f
);
    assign f = (x[3:2] == 2'b00) ? ~(x[1] & ~x[0]) :  // row00: 0 only at 01, else 1
               (x[3:2] == 2'b01) ? (x[1] & x[0]) :    // row01: 1 only at 11
               (x[3:2] == 2'b11) ? ~x[1] :           // row11: 1 at 00 or 01
                                   ~(~x[1] & x[0]);   // row10: 0 at 10, else 1
endmodule
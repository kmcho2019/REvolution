module TopModule(
    input [3:0] x,
    output f
);
    assign f = (x[3] & ~x[0]) ? (x[1] | ~x[2]) :  // For x[3]x[0] = 10
               (~x[3] & x[0]) ? (x[1] & x[2]) :    // For x[3]x[0] = 01
               (x[3] & x[0]) ? ~x[2] :             // For x[3]x[0] = 11
               (~x[1] & x[2]);                     // For x[3]x[0] = 00
endmodule
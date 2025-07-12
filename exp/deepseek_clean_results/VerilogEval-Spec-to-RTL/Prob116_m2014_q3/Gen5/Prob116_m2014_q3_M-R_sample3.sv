module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0]
    output f
);
    // x[3]x[0] forms the row selection (MSB is x[3])
    // x[2]x[1] forms the column selection (MSB is x[2])
    assign f = (x[3] & x[0]) ? 
                  (x[2] | ~x[1]) :  // Row 11: 1 for all except x[2]x[1]=10
               (x[3] & ~x[0]) ? 
                  (~x[2] | ~x[1]) :  // Row 10: 1 for x[2]x[1]=00 or 01
               (~x[3] & x[0]) ? 
                  (x[2] & x[1]) :    // Row 01: 1 only for x[2]x[1]=11
               0;                   // Row 00: default 0 (with don't-cares)
endmodule
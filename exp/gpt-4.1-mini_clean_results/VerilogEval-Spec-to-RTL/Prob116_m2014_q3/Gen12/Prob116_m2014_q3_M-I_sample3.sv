module TopModule(
    input  [3:0] x,
    output       f
);
    // Inputs: x[3] x[2] x[1] x[0]
    // Implement minimized logic derived from K-map with don't-cares assigned optimally
    assign f = (x[3] & x[2])               // row 11: all ones except some don't-cares assigned 0
             | (x[3] & ~x[2] & ~x[1])     // row 10, columns 00 and 01
             | (~x[3] & x[2] & x[0]);     // row 01, column 01 (assigned d->1)

endmodule
module TopModule(
    input [3:0] x,  // x[3],x[2],x[1],x[0]
    output f
);
    // 16-bit LUT where each bit represents f(x[3:0])
    // Index is {x[3],x[2],x[1],x[0]}
    wire [15:0] lut = 16'b0000_1100_1010_0000;
    /* LUT breakdown by input (x[3:0]):
       0000:0 (d->0)  0100:0 (d->0)  1000:1      1100:1
       0001:0         0101:0 (d->0)  1001:1      1101:1 (d->0)
       0010:0 (d->0)  0110:0         1010:0 (d->0) 1110:0 (d->0)
       0011:0 (d->0)  0111:1         1011:0      1111:0 (d->0)
    */

    assign f = lut[x];
endmodule
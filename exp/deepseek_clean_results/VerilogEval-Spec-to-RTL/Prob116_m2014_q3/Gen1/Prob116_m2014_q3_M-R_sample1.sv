module TopModule(
    input [3:0] x,
    output f
);
    // x[3] is MSB, x[0] is LSB in Verilog (matches input [3:0] x)
    // Map to Karnaugh variables:
    // x[3] = x[3], x[4] = x[2], x[1] = x[1], x[2] = x[0]
    assign f = (x[3] & ~(x[2] & x[1] & ~x[0])) | (~x[3] & x[2] & x[1] & x[0]);
endmodule
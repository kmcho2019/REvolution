module TopModule(
    input  [3:0] x, // Note: Since Verilog array indices start at 0, x[3] corresponds to x[4] in the problem description, and so on.
    output f
);

assign f = (x[3] & x[2]) | (~x[3] & ~x[1] & x[2]);

endmodule
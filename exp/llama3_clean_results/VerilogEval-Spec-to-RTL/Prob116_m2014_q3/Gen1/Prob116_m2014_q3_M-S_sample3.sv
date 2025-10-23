module TopModule(
    input [3:0] x,
    output f
);

// The simplified logic implementation based on the Karnaugh map
// f = 1 when x[3] = 1 or (x[3] = 0, x[4] = 1, x[1] = 1, x[2] = 1)
assign f = x[3] | (x[4] & x[1] & x[2]);

endmodule
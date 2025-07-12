module TopModule(
    input [3:0] x,
    output f
);

assign f = (x[2] || x[3]) ? (x[0] == 1'b0 || x[1] == 1'b0) : (x[0] == 1'b0 && (x[1] == 1'b0 || x[1] == 1'b1));

endmodule
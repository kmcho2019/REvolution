module TopModule(
    input [3:0] x,
    output wire f
);

assign f = x[3] || (x[1] && x[2]);

endmodule
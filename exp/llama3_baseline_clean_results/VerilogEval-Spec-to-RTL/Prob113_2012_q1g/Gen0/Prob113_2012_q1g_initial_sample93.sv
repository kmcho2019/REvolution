module TopModule(
    input [3:0] x,
    output f
);

assign f = (x == 4'd0) | (x == 4'd3) | (x == 4'd9) | (x == 4'd11) | (x == 4'd12) | (x == 4'd13);

endmodule
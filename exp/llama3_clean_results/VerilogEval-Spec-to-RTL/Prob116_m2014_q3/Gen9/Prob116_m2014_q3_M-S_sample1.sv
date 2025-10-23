module TopModule(
    input [3:0] x,
    output f
);

// Simplified implementation focusing on conditions leading to '1'
assign f = (x[3] & (x[1] | x[2])) | (x[1] & x[2] & ~x[3]);

endmodule
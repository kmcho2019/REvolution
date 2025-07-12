module TopModule(
    input [3:0] x,
    output reg f
);

// Simplified implementation focusing on conditions leading to f being 1
assign f = (x[3]) || (x[1] && x[2]);

endmodule
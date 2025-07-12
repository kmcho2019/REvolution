module TopModule(
    input [3:0] x,
    output f
);

assign f = (x[2] && !x[1]) || (x[1] && x[2] && x[3]) || (x[3] && !x[1] && x[2]);

// Simplifying further based on the logic:
assign f = (x[2] && (!x[1] || (x[1] && x[3])) || (x[3] && !x[1] && x[2]);
// Which can be reduced to:
assign f = (x[3] && !x[1] && x[2]) || (x[2] && (!x[1] || x[3]));

// Further simplification based on the conditions:
assign f = x[2] && (!x[1] || x[3]);

endmodule
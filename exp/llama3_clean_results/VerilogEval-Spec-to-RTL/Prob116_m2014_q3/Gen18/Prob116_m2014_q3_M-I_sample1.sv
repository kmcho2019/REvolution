module TopModule(
    input [3:0] x,
    output wire f
);

// Since the Karnaugh map conditions directly relate to x[3], x[2], x[1], and x[0],
// we should focus on these bits for the logic implementation.
// The condition from the map can be simplified as follows:
// - When x[3] is 1, f = 1 unless both x[1] and x[2] are 0.
// - When x[3] is 0, f = 1 only when both x[1] and x[2] are 1.

// Simplified logic based on the conditions
assign f = (x[3] && (x[1] || x[2])) || (!x[3] && x[1] && x[2]);

endmodule
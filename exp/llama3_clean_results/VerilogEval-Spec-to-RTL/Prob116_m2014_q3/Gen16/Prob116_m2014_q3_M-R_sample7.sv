module TopModule(
    input [3:0] x,
    output wire f
);

// Directly implement the logic based on the Karnaugh map conditions
// The condition when x[3] is 1 covers all cases of x[1] and x[2] being anything except both 0,
// which is considered a don't-care for simplification purposes. When x[3] is 0, f is 1 only when x[1] and x[2] are both 1.
assign f = (x[3]) || (x[1] && x[2]);

endmodule
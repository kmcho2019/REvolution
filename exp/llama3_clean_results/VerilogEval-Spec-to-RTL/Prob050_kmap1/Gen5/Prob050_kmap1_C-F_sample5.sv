// Fuse the best ideas from both examples to create a superior solution
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Use a simple OR gate to implement the required functionality
assign out = a | b | c;

// Consider adding synthesis directives or constraints to encourage the tool to further optimize the design
// For example, the following directive can be used to specify the desired optimization goal
// (* optimization_goal = "area" *)
// assign out = a | b | c;

endmodule
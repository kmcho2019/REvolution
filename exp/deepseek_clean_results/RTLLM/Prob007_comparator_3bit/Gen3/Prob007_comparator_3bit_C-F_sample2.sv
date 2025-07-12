module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Direct comparison using arithmetic operators for optimal PPA
// Outputs are mutually exclusive by construction
assign A_greater = (A > B);
assign A_equal   = (A == B);
assign A_less    = (A < B);

// Property: Only one output can be high at any time
// assert property (@(posedge clk) $onehot0({A_greater, A_equal, A_less}));

endmodule
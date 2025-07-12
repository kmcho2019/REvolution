module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-slice comparison signals
wire [2:0] P;  // Propagate (equality)
wire [2:0] G;  // Generate (greater)
wire [2:0] L;  // Generate (less)

// Bit-slice comparisons
assign P[2] = (A[2] == B[2]);
assign G[2] = (A[2] > B[2]);
assign L[2] = (A[2] < B[2]);

assign P[1] = (A[1] == B[1]);
assign G[1] = (A[1] > B[1]);
assign L[1] = (A[1] < B[1]);

assign P[0] = (A[0] == B[0]);
assign G[0] = (A[0] > B[0]);
assign L[0] = (A[0] < B[0]);

// Hierarchical combination
wire greater_2_1 = G[2] | (P[2] & G[1]);
wire less_2_1 = L[2] | (P[2] & L[1]);

assign A_greater = greater_2_1 | (P[2] & P[1] & G[0]);
assign A_less = less_2_1 | (P[2] & P[1] & L[0]);
assign A_equal = P[2] & P[1] & P[0];

// Verification property (mutual exclusivity)
// assert property (@(*) $onehot0({A_greater, A_equal, A_less}));

endmodule
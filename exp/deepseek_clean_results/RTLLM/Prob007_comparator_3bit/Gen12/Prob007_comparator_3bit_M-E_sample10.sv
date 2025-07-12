module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Stage 1: MSB comparison (highest priority)
wire msb_gt = (A[2] & ~B[2]);
wire msb_eq = (A[2] == B[2]);
wire msb_lt = (~A[2] & B[2]);

// Stage 2: Middle bit comparison (medium priority, only if MSB equal)
wire mid_gt = msb_eq & (A[1] & ~B[1]);
wire mid_eq = msb_eq & (A[1] == B[1]);
wire mid_lt = msb_eq & (~A[1] & B[1]);

// Stage 3: LSB comparison (lowest priority, only if higher bits equal)
wire lsb_gt = msb_eq & mid_eq & (A[0] & ~B[0]);
wire lsb_eq = msb_eq & mid_eq & (A[0] == B[0]);
wire lsb_lt = msb_eq & mid_eq & (~A[0] & B[0]);

// Priority resolution (MSB dominates)
assign A_greater = msb_gt | (msb_eq & mid_gt) | (msb_eq & mid_eq & lsb_gt);
assign A_equal = msb_eq & mid_eq & lsb_eq;
assign A_less = msb_lt | (msb_eq & mid_lt) | (msb_eq & mid_eq & lsb_lt);

// Ensure mutual exclusivity (structurally guaranteed by design)
endmodule
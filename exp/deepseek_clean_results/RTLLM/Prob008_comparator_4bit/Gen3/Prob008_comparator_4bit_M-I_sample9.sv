module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] bit_eq;  // Bitwise equality
wire [3:0] bit_gt;   // Bitwise greater than
wire [3:0] bit_lt;   // Bitwise less than

// Generate bitwise comparison signals
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : bit_compare
        assign bit_eq[i] = (A[i] ~^ B[i]);  // XNOR for equality
        assign bit_gt[i] = A[i] & ~B[i];
        assign bit_lt[i] = ~A[i] & B[i];
    end
endgenerate

// Hierarchical comparison logic
wire gt3, gt2, gt1, gt0;
wire lt3, lt2, lt1, lt0;

assign gt3 = bit_gt[3];
assign gt2 = bit_eq[3] & bit_gt[2];
assign gt1 = bit_eq[3] & bit_eq[2] & bit_gt[1];
assign gt0 = bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0];

assign lt3 = bit_lt[3];
assign lt2 = bit_eq[3] & bit_lt[2];
assign lt1 = bit_eq[3] & bit_eq[2] & bit_lt[1];
assign lt0 = bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_lt[0];

// Final outputs
assign A_greater = gt3 | gt2 | gt1 | gt0;
assign A_equal = &bit_eq;  // All bits equal
assign A_less = lt3 | lt2 | lt1 | lt0;

endmodule
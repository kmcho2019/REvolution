module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality (more power efficient than XOR approach)
    wire [3:0] bit_eq = {A[3]~^B[3], A[2]~^B[2], A[1]~^B[1], A[0]~^B[0]};
    wire equal = &bit_eq;  // All bits equal
    
    // Magnitude comparison with shared logic
    wire [3:0] bit_gt = {A[3]&~B[3], A[2]&~B[2], A[1]&~B[1], A[0]&~B[0]};
    wire [3:0] bit_lt = {~A[3]&B[3], ~A[2]&B[2], ~A[1]&B[1], ~A[0]&B[0]};
    
    // Parallel priority encoding for greater/less
    wire greater = bit_gt[3] | 
                  (bit_eq[3] & bit_gt[2]) | 
                  (bit_eq[3] & bit_eq[2] & bit_gt[1]) | 
                  (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);
    
    wire less = bit_lt[3] | 
               (bit_eq[3] & bit_lt[2]) | 
               (bit_eq[3] & bit_eq[2] & bit_lt[1]) | 
               (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_lt[0]);

    // Output assignments (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = less;

endmodule
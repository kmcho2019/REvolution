module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Detect 0 ones case
    wire zero_ones = ~a & ~b & ~c & ~d;
    
    // Detect 2 ones cases (6 combinations)
    wire two_ones_ab = a & b & ~c & ~d;
    wire two_ones_ac = a & c & ~b & ~d;
    wire two_ones_ad = a & d & ~b & ~c;
    wire two_ones_bc = b & c & ~a & ~d;
    wire two_ones_bd = b & d & ~a & ~c;
    wire two_ones_cd = c & d & ~a & ~b;
    wire any_two_ones = two_ones_ab | two_ones_ac | two_ones_ad | 
                       two_ones_bc | two_ones_bd | two_ones_cd;
    
    // Detect 4 ones case
    wire four_ones = a & b & c & d;
    
    // Final output
    assign q = zero_ones | any_two_ones | four_ones;
endmodule
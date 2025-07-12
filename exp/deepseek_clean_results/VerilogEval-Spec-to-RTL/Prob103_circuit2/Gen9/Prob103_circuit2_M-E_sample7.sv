module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // All zero case
    wire all_zero = ~a & ~b & ~c & ~d;
    
    // Two-input true cases (6 combinations)
    wire case_ab = a & b & ~c & ~d;
    wire case_ac = a & c & ~b & ~d;
    wire case_ad = a & d & ~b & ~c;
    wire case_bc = b & c & ~a & ~d;
    wire case_bd = b & d & ~a & ~c;
    wire case_cd = c & d & ~a & ~b;
    
    // All one case
    wire all_one = a & b & c & d;
    
    // Combine all cases where even number of inputs are 1
    assign q = all_zero | case_ab | case_ac | case_ad | 
               case_bc | case_bd | case_cd | all_one;

endmodule
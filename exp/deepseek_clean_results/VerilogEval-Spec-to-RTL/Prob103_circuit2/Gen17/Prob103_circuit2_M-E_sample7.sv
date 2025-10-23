module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // All zeros case
    wire case0 = ~a & ~b & ~c & ~d;
    
    // Exactly two ones cases (6 combinations)
    wire case2_ab = a & b & ~c & ~d;
    wire case2_ac = a & c & ~b & ~d;
    wire case2_ad = a & d & ~b & ~c;
    wire case2_bc = b & c & ~a & ~d;
    wire case2_bd = b & d & ~a & ~c;
    wire case2_cd = c & d & ~a & ~b;
    
    // All ones case
    wire case4 = a & b & c & d;
    
    // Combine all even-parity cases
    assign q = case0 | case2_ab | case2_ac | case2_ad | 
               case2_bc | case2_bd | case2_cd | case4;

endmodule
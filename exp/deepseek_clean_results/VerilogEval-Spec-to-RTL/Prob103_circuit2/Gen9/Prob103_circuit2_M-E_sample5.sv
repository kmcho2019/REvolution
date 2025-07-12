module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // All zeros or all ones
    wire all_equal = (~a & ~b & ~c & ~d) | (a & b & c & d);
    
    // Exactly two adjacent ones (considering circular adjacency)
    wire two_adjacent = 
        (~a & ~b & c & d) |  // 0011
        (~a & b & ~c & d) |   // 0101
        (~a & b & c & ~d) |   // 0110
        (a & ~b & ~c & d) |   // 1001
        (a & ~b & c & ~d) |  // 1010
        (a & b & ~c & ~d);    // 1100
    
    assign q = all_equal | two_adjacent;
endmodule
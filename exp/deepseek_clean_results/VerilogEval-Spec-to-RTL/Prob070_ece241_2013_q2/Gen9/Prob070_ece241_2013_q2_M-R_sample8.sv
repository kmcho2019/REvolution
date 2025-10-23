module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation with intermediate wires
    wire minterm_2 = ~a & ~b & c & ~d;  // 2 (0010)
    wire minterm_7 = ~a & b & c & d;    // 7 (0111)
    wire minterm_15 = a & b & c & d;    // 15 (1111)
    assign out_sop = minterm_2 | minterm_7 | minterm_15;

    // POS implementation with intermediate wires
    wire maxterm_group1 = ~b | ~c | ~d;             // Blocks 0,1,4,5
    wire maxterm_group2 = a | ~b | ~c;              // Blocks 6,14
    wire maxterm_group3 = ~a | b | ~c | d;          // Blocks 9,13
    wire maxterm_group4 = a | b | ~c | ~d;          // Blocks 10
    assign out_pos = maxterm_group1 & maxterm_group2 & 
                    maxterm_group3 & maxterm_group4;

endmodule
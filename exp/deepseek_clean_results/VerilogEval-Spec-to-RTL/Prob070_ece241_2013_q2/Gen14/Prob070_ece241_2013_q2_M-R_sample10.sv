module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation (direct minterms)
    wire term_2  = ~a & ~b &  c & ~d;  // 0010 (2)
    wire term_7  = ~a &  b &  c &  d;  // 0111 (7)
    wire term_15 =  a &  b &  c &  d;  // 1111 (15)
    assign out_sop = term_2 | term_7 | term_15;

    // POS implementation via complement function
    // First create SOP of complement (output=0 cases)
    wire comp_0  = ~a & ~b & ~c & ~d;  // 0000 (0)
    wire comp_1  = ~a & ~b & ~c &  d;  // 0001 (1)
    wire comp_4  = ~a &  b & ~c & ~d;  // 0100 (4)
    wire comp_5  = ~a &  b & ~c &  d;  // 0101 (5)
    wire comp_6  = ~a &  b &  c & ~d;  // 0110 (6)
    wire comp_9  =  a & ~b & ~c &  d;  // 1001 (9)
    wire comp_10 =  a & ~b &  c & ~d;  // 1010 (10)
    wire comp_13 =  a &  b & ~c &  d;  // 1101 (13)
    wire comp_14 =  a &  b &  c & ~d;  // 1110 (14)
    wire complement = comp_0 | comp_1 | comp_4 | comp_5 | 
                     comp_6 | comp_9 | comp_10 | comp_13 | comp_14;

    // Apply De Morgan's to get POS form
    assign out_pos = ~complement;

endmodule
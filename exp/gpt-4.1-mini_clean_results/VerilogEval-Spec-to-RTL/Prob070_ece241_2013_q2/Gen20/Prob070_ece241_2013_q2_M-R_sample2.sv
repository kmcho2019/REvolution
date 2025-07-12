module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Combine inputs into 4-bit vector, a is MSB, d is LSB
    wire [3:0] in = {a,b,c,d};

    // Define signals for minterms where function=1: 2,7,15
    wire m2  = (in == 4'd2);   // 0010
    wire m7  = (in == 4'd7);   // 0111
    wire m15 = (in == 4'd15);  // 1111

    // Implement out_sop as SOP: sum of minterms 2,7,15
    assign out_sop = m2 | m7 | m15;

    // Maxterms (zeros) given: 0,1,4,5,6,9,10,13,14
    // Each maxterm is a sum term corresponding to the input bits inverted where the maxterm bits are 0.
    // Product of sums is AND of these sum terms.

    // Write each maxterm as a sum of literals:
    // Maxterm 0: 0000 -> (a + b + c + d)
    // Maxterm 1: 0001 -> (a + b + c + ~d)
    // Maxterm 4: 0100 -> (a + ~b + c + d)
    // Maxterm 5: 0101 -> (a + ~b + c + ~d)
    // Maxterm 6: 0110 -> (a + ~b + ~c + d)
    // Maxterm 9: 1001 -> (~a + b + c + ~d)
    // Maxterm 10:1010 -> (~a + b + ~c + d)
    // Maxterm 13:1101 -> (~a + ~b + c + ~d)
    // Maxterm 14:1110 -> (~a + ~b + ~c + d)

    assign out_pos =
           ( a  |  b  |  c  |  d  )
        &  ( a  |  b  |  c  | ~d  )
        &  ( a  | ~b  |  c  |  d  )
        &  ( a  | ~b  |  c  | ~d  )
        &  ( a  | ~b  | ~c  |  d  )
        &  (~a  |  b  |  c  | ~d  )
        &  (~a  |  b  | ~c  |  d  )
        &  (~a  | ~b  |  c  | ~d  )
        &  (~a  | ~b  | ~c  |  d  );

endmodule
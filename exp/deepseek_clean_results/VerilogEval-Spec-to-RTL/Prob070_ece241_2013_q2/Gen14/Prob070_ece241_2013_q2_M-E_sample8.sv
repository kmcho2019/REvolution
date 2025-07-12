module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized SOP implementation
    assign out_sop = c & (
        (~a & ~b & ~d) |  // Case 2
        (~a & b & d) |    // Case 7
        (a & b & d)       // Case 15
    );

    // Optimized POS implementation using inverted SOP
    wire out_pos_temp;
    assign out_pos_temp = ~c | (  // Inverted output cases
        (a | b | d) &             // Not case 2
        (a | ~b | ~d) &           // Not case 7
        (~a | ~b | ~d)            // Not case 15
    );
    assign out_pos = ~out_pos_temp;

endmodule
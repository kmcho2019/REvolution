module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    wire [3:0] in = {a, b, c, d};

    // out_sop = 1 when in == 2, 7, or 15
    assign out_sop = (in == 4'd2) | (in == 4'd7) | (in == 4'd15);

    // Zeros: 0,1,4,5,6,9,10,13,14
    // Each zero corresponds to a maxterm (sum term), out_pos = AND of all maxterms.
    // Express maxterms as per bits:
    // For zero 0 (0000): (a + b + c + d)
    // For zero 1 (0001): (a + b + c + ~d)
    // For zero 4 (0100): (a + ~b + c + d)
    // For zero 5 (0101): (a + ~b + c + ~d)
    // For zero 6 (0110): (a + ~b + ~c + d)
    // For zero 9 (1001): (~a + b + ~c + ~d)
    // For zero 10(1010): (~a + b + c + ~d)
    // For zero 13(1101): (~a + ~b + c + ~d)
    // For zero 14(1110): (~a + ~b + ~c + d)

    assign out_pos =
        ( a |  b |  c |  d) &  // 0
        ( a |  b |  c | ~d) &  // 1
        ( a | ~b |  c |  d) &  // 4
        ( a | ~b |  c | ~d) &  // 5
        ( a | ~b | ~c |  d) &  // 6
        (~a |  b | ~c | ~d) &  // 9
        (~a |  b |  c | ~d) &  //10
        (~a | ~b |  c | ~d) &  //13
        (~a | ~b | ~c |  d);   //14

endmodule
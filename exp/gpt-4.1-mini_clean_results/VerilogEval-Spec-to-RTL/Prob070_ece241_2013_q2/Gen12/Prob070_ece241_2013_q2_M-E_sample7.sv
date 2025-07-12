module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Inputs as a 4-bit vector for clarity:
    wire [3:0] in_vec = {a,b,c,d};

    // The output is 1 when input is 2, 7, or 15.
    // Inputs 3,8,11,12 never occur - treat as don't cares.
    // Output is 0 when input is 0,1,4,5,6,9,10,13,14.

    // After Karnaugh map minimization considering don't cares, minimal SOP:
    // out_sop = ( ~a &  c & ~d ) | ( ~a & b & d ) | ( a & b & c & d )
    // This corresponds to:
    // - Term1: a=0,b=don't care,c=1,d=0  => ~a & c & ~d
    // - Term2: a=0,b=1,c=don't care,d=1  => ~a & b & d
    // - Term3: a=1,b=1,c=1,d=1           => a & b & c & d

    assign out_sop = (~a &  c & ~d) | (~a & b & d) | (a & b & c & d);

    // Minimal POS expression considering don't cares and zeros:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d)
    // (This is the minimal POS covering the zeros and excluding the minterms above)

    assign out_pos = (a | b | ~c | d) & (a | ~b | c | d) & (~a | b | c | ~d);

endmodule
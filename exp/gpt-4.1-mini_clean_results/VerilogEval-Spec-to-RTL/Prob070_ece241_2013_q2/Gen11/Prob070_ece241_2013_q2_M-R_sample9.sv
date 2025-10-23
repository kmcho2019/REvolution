module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // a: MSB, d: LSB
    // Input binary to decimal mapping (a b c d):
    // 2  = 0 0 1 0
    // 7  = 0 1 1 1
    // 15 = 1 1 1 1
    //
    // out_sop = 1 when input is 2,7,15
    // Minimal SOP from these minterms:
    // Minterm for 2:  ~a & ~b &  c & ~d
    // Minterm for 7:  ~a &  b &  c &  d
    // Minterm for 15: a  &  b &  c &  d

    wire m2  = ~a & ~b &  c & ~d;
    wire m7  = ~a &  b &  c &  d;
    wire m15 =  a &  b &  c &  d;

    assign out_sop = m2 | m7 | m15;

    // For out_pos, output=1 when input is in {0,1,4,5,6,9,10,13,14}
    // Inputs 3,8,11,12 never occur (don't care)
    // The minimal POS covers zeros (where out_pos=0) at 2,7,15 (which are out_sop=1)
    // The minimal POS expression for out_pos is:
    //
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d)
    //
    // This matches exactly the complement of the SOP minterms for out_sop.

    assign out_pos = (a | b | ~c | d) & (a | ~b | c | d) & (~a | b | c | ~d);

endmodule
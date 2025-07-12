module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Direct minterm matching for out_sop:
    // 2  =  0010 = a=0,b=0,c=1,d=0
    // 7  =  0111 = a=0,b=1,c=1,d=1
    // 15 =  1111 = a=1,b=1,c=1,d=1

    wire is_two  = (~a & ~b &  c & ~d);
    wire is_seven= (~a &  b &  c &  d);
    wire is_fifteen = (a & b & c & d);

    assign out_sop = is_two | is_seven | is_fifteen;

    // For out_pos, use minimal product-of-sums covering zeros:
    // Zeros: 0,1,4,5,6,9,10,13,14
    // Minimal POS from these zeros:
    // (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d)

    assign out_pos = (a | b | ~c | d) & (a | ~b | c | d) & (~a | b | c | ~d);

endmodule
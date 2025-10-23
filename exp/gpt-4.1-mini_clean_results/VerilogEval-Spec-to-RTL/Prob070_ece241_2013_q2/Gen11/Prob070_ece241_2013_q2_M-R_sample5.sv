module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Inputs: a b c d
    // Numbers:
    //  0=0000,1=0001,2=0010,3=0011,4=0100,5=0101,6=0110,7=0111,
    //  8=1000,9=1001,10=1010,11=1011,12=1100,13=1101,14=1110,15=1111

    // Function=1 for decimal inputs 2,7,15
    // Function=0 for 0,1,4,5,6,9,10,13,14
    // Inputs 3,8,11,12 never occur (treat as don't cares = 0)

    // Minimal SOP (sum of products) derived:
    // f = a b c d + (~a) b c d + (~a) (~b) c (~d)
    // where '~' means NOT
    // Translate:
    // term1: a b c d (1111)
    // term2: ~a b c d (0111)
    // term3: ~a ~b c ~d (0010)

    // Minimal POS (product of sums) derived:
    // f = (a + b + ~c + d)(a + ~b + c + d)(~a + b + c + d)
    // which is the product of these three maxterms.

    wire not_a = ~a;
    wire not_b = ~b;
    wire not_c = ~c;
    wire not_d = ~d;

    // SOP implementation
    assign out_sop = (a & b & c & d) | (not_a & b & c & d) | (not_a & not_b & c & not_d);

    // POS implementation
    // First sum terms:
    wire sum1 = a | b | not_c | d;
    wire sum2 = a | not_b | c | d;
    wire sum3 = not_a | b | c | d;

    assign out_pos = sum1 & sum2 & sum3;

endmodule
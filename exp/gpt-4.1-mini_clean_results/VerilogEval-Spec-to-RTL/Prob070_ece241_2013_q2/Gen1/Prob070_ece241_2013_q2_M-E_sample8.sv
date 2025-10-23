module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Detect inputs representing decimal 2, 7, and 15 explicitly
wire is_2  = (~a) & (~b) &  c  & (~d); // 0 0 1 0
wire is_7  = (~a) &  b  &  c  &  d;    // 0 1 1 1
wire is_15 =  a   &  b  &  c  &  d;    // 1 1 1 1

// Sum-Of-Products: output 1 if input is 2,7 or 15
assign out_sop = is_2 | is_7 | is_15;

// Detect zeros explicitly for product-of-sums
// Zero inputs: 0,1,4,5,6,9,10,13,14
// For each zero input, create a maxterm that is 0 only for that input, else 1
// Maxterm for zero input x: OR of literals where each literal is input if bit=0 else ~input

wire m0  = (a | b | c | d);           // 0000
wire m1  = (a | b | c | ~d);          // 0001
wire m4  = (a | ~b | c | d);          // 0100
wire m5  = (a | ~b | c | ~d);         // 0101
wire m6  = (a | ~b | ~c | d);         // 0110
wire m9  = (~a | b | c | ~d);         // 1001
wire m10 = (~a | b | ~c | d);          // 1010
wire m13 = (~a | ~b | c | d);          // 1101
wire m14 = (~a | ~b | ~c | d);         // 1110

// Product-Of-Sums: output 1 only if all maxterms are 1 (i.e., input not in zeros)
assign out_pos = m0 & m1 & m4 & m5 & m6 & m9 & m10 & m13 & m14;

endmodule
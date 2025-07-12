module TopModule (
    input  a, // MSB
    input  b,
    input  c,
    input  d, // LSB
    output out_sop,
    output out_pos
);

// Pack inputs into a 4-bit vector for clarity; a is MSB, d is LSB
wire [3:0] in_vec = {a,b,c,d};

// Minimal SOP form from the specified numbers: 2(0010),7(0111),15(1111)
// Corresponding expressions:
// 2  = ~a & ~b &  c & ~d
// 7  = ~a &  b &  c &  d
// 15 =  a &  b &  c &  d

assign out_sop = (~in_vec[3] & ~in_vec[2] &  in_vec[1] & ~in_vec[0]) |
                 (~in_vec[3] &  in_vec[2] &  in_vec[1] &  in_vec[0]) |
                 ( in_vec[3] &  in_vec[2] &  in_vec[1] &  in_vec[0]);

// Minimal POS form:
// (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + d)
// Translate to vector bits:
// (in_vec[3] + in_vec[2] + ~in_vec[1] + in_vec[0]) &
// (in_vec[3] + ~in_vec[2] + in_vec[1] + in_vec[0]) &
// (~in_vec[3] + in_vec[2] + in_vec[1] + in_vec[0])

assign out_pos = (in_vec[3] | in_vec[2] | ~in_vec[1] | in_vec[0]) &
                 (in_vec[3] | ~in_vec[2] | in_vec[1] | in_vec[0]) &
                 (~in_vec[3] | in_vec[2] | in_vec[1] | in_vec[0]);

endmodule
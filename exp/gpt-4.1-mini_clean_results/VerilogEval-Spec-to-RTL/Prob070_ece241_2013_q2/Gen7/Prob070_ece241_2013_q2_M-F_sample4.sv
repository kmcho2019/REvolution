module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP expression with don't-cares (3,8,11,12) included for simplification:
//  2  = 0 0 1 0 => ~a & ~b &  c & ~d
//  7  = 0 1 1 1 => ~a &  b &  c &  d
// 15  = 1 1 1 1 =>  a &  b &  c &  d
// Simplified SOP:
assign out_sop =
    (a & b & c) |             // Covers 15 (1111) and includes part of others
    (~a & b & c & d) |        // Covers 7 (0111)
    (~a & ~b & c & ~d);       // Covers 2 (0010)

// Minimal POS expression with don't-cares:
// 0,1,4,5,6,9,10,13,14 = zeros to cover
// Simplified POS:
assign out_pos =
    (a | b | ~c | d) &
    (a | ~b | ~c | ~d) &
    (~a | b | ~c | ~d);

endmodule
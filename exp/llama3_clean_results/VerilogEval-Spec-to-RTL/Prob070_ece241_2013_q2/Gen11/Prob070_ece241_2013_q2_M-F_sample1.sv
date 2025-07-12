module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a & b &!c &!d) || (!a & b & c & d) || (a & b & c & d);

// Minimum Product-of-Sums (POS) form for out_pos
// The output should be 1 when none of the out_sop conditions are met
// This involves finding the sums that represent the conditions where the output should be 0
// and then finding the product of these sums.

// The conditions for out_pos being 0 are the complements of the conditions for 2, 7, and 15
// Let's express these conditions as sums and find their product.

// The sum of the complements of the conditions for 2, 7, and 15 can be derived as follows:
// - The complement of 2 (0010) is!(a=0, b=1, c=0, d=0), which can be expressed as (a ||!b || c || d)
// - The complement of 7 (0111) is!(a=0, b=1, c=1, d=1), which can be expressed as (a ||!b ||!c ||!d)
// - The complement of 15 (1111) is!(a=1, b=1, c=1, d=1), which can be expressed as (!a ||!b ||!c ||!d)

// The POS form for out_pos can be derived as the product of these sums:
assign out_pos = (a ||!b || c || d) && (a ||!b ||!c ||!d) && (!a ||!b ||!c ||!d);

endmodule
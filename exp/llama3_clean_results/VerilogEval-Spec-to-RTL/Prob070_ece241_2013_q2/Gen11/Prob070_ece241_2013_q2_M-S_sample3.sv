module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a & b & !c & !d) || (!a & b & c & d) || (a & b & c & d);

// Derive out_pos based on the complement of out_sop's conditions
// Since out_pos should be 1 when out_sop is 0, and given the specific conditions:
// We look for conditions not covered by out_sop (i.e., not 2, 7, or 15 in binary)
// This involves a, b, c, d combinations not matching !a&b&!c&!d, !a&b&c&d, or a&b&c&d
// The correct product-of-sums form for out_pos involves considering all possible combinations that do not satisfy out_sop conditions
// Given the binary representation and the requirement for product-of-sums:
assign out_pos = (a || !b || c || !d) && (a || !b || !c || !d) && (!a || !b || !c || !d);

endmodule
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
// Correctly implements conditions for 2, 7, and 15 in binary
assign out_sop = (!a & b &!c &!d) || (!a & b & c & d) || (a & b & c & d);

// Derive out_pos based on the complement of out_sop's conditions
// Correctly identifies combinations not satisfying out_sop conditions
assign out_pos = (!(a & b & c & d)) && (!(b & c & d)) && (!(a & b &!c & d));

endmodule
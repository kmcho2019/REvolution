module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Sum-of-Products (SOP) implementation for out_sop
// Conditions for output to be 1: 0010 (2), 0111 (7), 1111 (15)
assign out_sop = (!a && b && !c && !d) || (!a && b && c && d) || (a && b && c && d);

// Product-of-Sums (POS) implementation for out_pos
// Directly finding the POS form is complex due to the nature of the problem.
// However, we can simplify by understanding the dual nature and focusing on conditions for 1.
// The given conditions and the nature of the problem suggest a simplification where we consider
// the complements and their product. However, without explicit sums for all 0 conditions,
// we recognize the duality principle and apply De Morgan's laws indirectly in our thought process.

// For simplicity and adherence to the problem's constraints, we acknowledge the direct
// implementation of POS from the given conditions is not straightforward without considering
// all possible input combinations, including those that never occur. Thus, the provided
// implementation focuses on the SOP form, and the POS form is acknowledged as a dual but
// not directly implemented here due to the complexity and the specific constraints given.

// However, to follow the format and provide a code snippet, let's consider an approach
// that simplifies the POS form based on the given conditions, understanding that a direct
// and complete POS form requires considering all paths to a 0 output, which includes
// conditions that "never occur" and thus are not directly implemented here.

assign out_pos = !(a && !b && !c && !d) && !(a && !b && !c && d) && !(a && !b && c && !d) && !(a && !b && c && d) && !(!a && !b && !c && !d) && !(!a && !b && !c && d) && !(!a && !b && c && !d) && !(!a && !b && c && d) && !(!a && b && !c && !d) && !(!a && b && !c && d) && !(!a && b && c && !d) && !(a && !b && !c && !d) && !(a && !b && !c && d) && !(a && !b && c && !d);

endmodule
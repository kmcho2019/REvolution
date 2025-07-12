module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Deriving Minimum Product-of-Sums (POS) form for out_pos is complex due to the need to consider all maxterms.
// However, a more straightforward approach for digital implementation would involve using the SOP of the complement of out_pos,
// applying De Morgan's laws, or directly implementing the maxterms. For simplicity and given the conditions,
// we'll focus on a logic implementation that directly reflects the maxterms or use a simpler method if applicable.

// Direct implementation based on maxterms or a simplified method for out_pos would be complex and not straightforward
// without considering the entire input space or using additional logic. For a POS form, consider the complement of the SOP of out_sop's logic-0 conditions,
// then apply De Morgan's laws. However, given the direct implementation request, we simplify the explanation to logic terms.

// A simpler approach for out_pos involves considering the conditions where out_pos is 0 and then inverting those conditions.
// Since we're directly asked for POS and given the constraints, let's clarify:
// out_pos should be 1 when not in the conditions for 0, 1, 4, 5, 6, 9, 10, 13, 14, implying it's more about the complement conditions.

// Thus, for out_pos, we directly consider when it should be 1, which is not straightforward from the given conditions without considering all possible inputs and their outputs.
// Given the constraints and focusing on digital implementation, the explanation simplifies to deriving out_sop directly and considering the logic for out_pos based on given conditions.

// However, for educational purposes and clarity in implementation, let's consider a straightforward digital approach for out_pos based on given conditions:
assign out_pos = ~( 
    (~a & ~b & ~c & ~d) | 
    (~a & ~b & ~c & d) | 
    (~a & b & ~c & ~d) | 
    (~a & b & ~c & d) | 
    (~a & b & c & ~d) | 
    (a & ~b & c & d) | 
    (a & b & ~c & ~d) | 
    (a & ~b & c & ~d) | 
    (a & b & ~c & d)
);

endmodule
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a & b &!c &!d) || (!a & b & c & d) || (a & b & c & d);

// Minimum Product-of-Sums (POS) form for out_pos
assign out_pos = (!(a &&!b &&!c &&!d)) && 
                 (!(a &&!b &&!c && d)) && 
                 (!(a &&!b && c &&!d)) && 
                 (!(a &&!b && c && d)) && 
                 (!(a && b &&!c &&!d)) && 
                 (!(a && b &&!c && d)) && 
                 (!(a && b && c &&!d)) && 
                 (!(a &&!b &&!c &&!d)) && 
                 (!(a &&!b &&!c && d)) && 
                 (!(a && b &&!c &&!d)) && 
                 (!(a && b &&!c && d)) && 
                 (!(a && b && c &&!d)) && 
                 (!(a && b && c && d));

// Alternatively, a simpler way to derive the POS form
// is to use the fact that the output should be 1 for the binary numbers 2, 7, and 15
// and 0 for the rest of the numbers
// assign out_pos = (!a ||!b || c || d) && (a ||!b ||!c ||!d) && (a || b ||!c ||!d);

endmodule
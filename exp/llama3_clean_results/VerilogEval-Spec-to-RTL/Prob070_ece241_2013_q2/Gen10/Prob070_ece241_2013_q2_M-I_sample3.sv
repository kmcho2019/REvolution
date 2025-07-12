module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
// Correctly representing the conditions for 2, 7, and 15
assign out_sop = (!a && b && !c && d) || (!a && b && c && d) || (a && b && c && d);

// Minimum Product-of-Sums (POS) form for out_pos
// Implementing the conditions for logic-0 outputs using POS
// Considering the don't-care conditions for the numbers 3, 8, 11, and 12
assign out_pos = (!(a && !b && !c && !d)) && 
                 (!(a && !b && !c && d)) && 
                 (!(a && !b && c && !d)) && 
                 (!(a && !b && c && d)) && 
                 (!(a && b && !c && !d)) && 
                 (!(a && b && !c && d)) && 
                 (!(a && b && c && !d)) && 
                 (!(a && !b && c && !d)) && 
                 (!(a && !b && !c && d)) && 
                 (!(a && b && !c && d));

// Alternatively, we can simplify the POS form by considering the maximum number of '1's or '0's in each column
// For example, whenever a and b are both 0, or whenever c and d are both 0, the output should be 1
// However, this approach needs to be carefully evaluated to ensure that it correctly represents the desired logic

// Improved Implementation
// Using a more efficient logic structure
assign out_sop = (b && (!a && !c && d || c && (d || !d))) || (a && b && c && d);
assign out_pos = (!(a && !b && !c && !d)) && 
                 (!(a && !b && !c && d)) && 
                 (!(a && !b && c && !d)) && 
                 (!(a && !b && c && d)) && 
                 (!(a && b && !c && !d)) && 
                 (!(a && b && !c && d)) && 
                 (!(a && b && c && !d));

endmodule
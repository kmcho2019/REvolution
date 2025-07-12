module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Sum-of-Products (SOP) for the conditions where output should be 1
assign out_sop = (!a && b && !c && !d) || 
                 (!a && b && c && d) || 
                 (a && b && c && d);

// Product-of-Sums (POS) for the conditions where output should be 0
assign out_pos = !( (!a && !b && !c && !d) || 
                   (!a && !b && !c && d) || 
                   (!a && !b && c && !d) || 
                   (!a && !b && c && d) || 
                   (!a && b && !c && !d) || 
                   (!a && b && !c && d) || 
                   (!a && b && c && !d) || 
                   (a && !b && !c && !d) || 
                   (a && !b && !c && d) || 
                   (a && !b && c && !d) || 
                   (a && b && !c && !d) );

endmodule
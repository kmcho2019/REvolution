module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Directly implement SOP as the OR of minterms for numbers 2, 7, and 15
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Directly implement POS as the AND of maxterms for undesired conditions
assign out_pos = (~a | ~b | ~c | ~d) & 
                 (~a | ~b | ~c | d) & 
                 (~a | b | ~c | ~d) & 
                 (~a | b | ~c | d) & 
                 (~a | b | c | ~d) & 
                 (a | ~b | ~c | d) & 
                 (a | ~b | c | ~d) & 
                 (a | b | ~c | d) & 
                 (a | b | c | ~d);

endmodule
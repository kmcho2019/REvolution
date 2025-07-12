module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Product-of-Sums (POS) form
// Directly implementing the maxterms as sums and then taking the product
assign out_pos = ~( (a | b | c | d) & 
                    (~a | ~b | ~c | ~d) & 
                    (~a | ~b | c | ~d) & 
                    (~a | b | ~c | ~d) & 
                    (~a | b | ~c | d) & 
                    (~a | b | c | ~d) & 
                    (a | ~b | ~c | ~d) & 
                    (a | ~b | ~c | d) & 
                    (a | ~b | c | ~d) & 
                    (a | b | ~c | ~d) );

endmodule
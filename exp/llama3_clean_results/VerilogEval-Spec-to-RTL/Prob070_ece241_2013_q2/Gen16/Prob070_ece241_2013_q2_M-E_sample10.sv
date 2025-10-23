module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Implement the SOP expression using logical operations
assign out_sop = ((~a & ~b & c & ~d) | 
                  (~a & b & c & d) | 
                  (a & b & c & d));

// Implement the POS expression using logical operations
assign out_pos = ((a | b | c | d) & 
                  (a | b | c | ~d) & 
                  (a | ~b | c | d) & 
                  (a | ~b | c | ~d) & 
                  (a | b | ~c | d) & 
                  (~a | b | c | ~d) & 
                  (~a | b | c | d) & 
                  (~a | ~b | c | ~d) & 
                  (~a | ~b | c | d));

endmodule
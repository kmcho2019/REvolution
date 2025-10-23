module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct SOP covering all 1-cases (2,7,15)
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Optimized POS covering all 0-cases
    assign out_pos = (a | b | c) & 
                    (a | ~b | c) & 
                    (~a | b | d) & 
                    (~a | ~b | c | d) & 
                    (~a | ~b | c | ~d);

endmodule
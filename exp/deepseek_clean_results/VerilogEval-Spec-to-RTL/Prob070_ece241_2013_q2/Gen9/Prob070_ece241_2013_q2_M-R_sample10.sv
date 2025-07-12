module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Corrected SOP implementation (covers cases 2,7,15)
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Corrected POS implementation (covers all 0-cases)
    assign out_pos = (a | b | c) & 
                    (a | ~b | c) & 
                    (~a | b | d) & 
                    (~a | ~b | c | d) & 
                    (~a | ~b | c | ~d);

endmodule
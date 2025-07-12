module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct Sum of Products (SOP) form
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Correct Product of Sums (POS) form
    assign out_pos = (a | c) & (a | ~b) & 
                    (~a | b | ~c | d) & 
                    (~a | ~b | c | ~d) & 
                    (~a | ~b | ~c | d) & 
                    (~a | b | c | ~d);

endmodule
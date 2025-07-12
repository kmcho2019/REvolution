module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimized Sum of Products (SOP) form
    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Minimized Product of Sums (POS) form
    assign out_pos = (a | b | c) &
                    (a | b | d) &
                    (a | c | d) &
                    (b | c | ~d) &
                    (~a | ~b | ~c | d);

endmodule
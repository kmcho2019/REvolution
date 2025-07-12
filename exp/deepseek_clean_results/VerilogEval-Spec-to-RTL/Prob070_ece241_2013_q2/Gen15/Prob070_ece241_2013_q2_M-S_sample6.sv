module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimized SOP implementation
    assign out_sop = (~a & b & c) | (a & b & c & d);

    // Minimized POS implementation
    assign out_pos = (b & c) & (a | d);

endmodule
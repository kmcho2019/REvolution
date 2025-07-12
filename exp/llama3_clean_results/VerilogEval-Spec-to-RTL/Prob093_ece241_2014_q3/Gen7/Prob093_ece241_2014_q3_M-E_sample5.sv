module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // For 'ab' = '00', output is 1 if c or d is 1
    assign mux_in[0] = c ? 1 : d;

    // For 'ab' = '01', output is always 0
    assign mux_in[1] = 0;

    // For 'ab' = '10', output is 1 if c is 1, regardless of d
    assign mux_in[2] = c ? 1 : d;

    // For 'ab' = '11', output is 1 if c or d (or both) is 1
    assign mux_in[3] = c || d;

endmodule
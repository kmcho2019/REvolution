module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // For 'ab' = '00'
    assign mux_in[0] = c ? 1 : d;

    // For 'ab' = '01', always '0'
    assign mux_in[1] = 0;

    // For 'ab' = '10'
    assign mux_in[2] = c ? 1 : d;

    // For 'ab' = '11'
    assign mux_in[3] = d ? c : 0;

endmodule
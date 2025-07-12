module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = c || d;  // For 'ab' = '00'
    assign mux_in[1] = 0;       // For 'ab' = '01', always '0'
    assign mux_in[2] = (c == 1) ? d : 1;  // For 'ab' = '10', use 2-to-1 multiplexer logic
    assign mux_in[3] = c && d;  // For 'ab' = '11'

endmodule
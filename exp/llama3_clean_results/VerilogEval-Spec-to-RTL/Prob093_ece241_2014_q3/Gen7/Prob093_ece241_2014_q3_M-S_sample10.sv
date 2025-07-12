module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // For 'ab' = '00' and 'ab' = '10', output is '1' when 'c' is '1'
    assign mux_in[0] = c ? 1 : d;
    assign mux_in[2] = c;

    // For 'ab' = '01', always '0'
    assign mux_in[1] = 0;

    // For 'ab' = '11', output is '1' when 'c' or 'd' is '1'
    assign mux_in[3] = c || d;

endmodule
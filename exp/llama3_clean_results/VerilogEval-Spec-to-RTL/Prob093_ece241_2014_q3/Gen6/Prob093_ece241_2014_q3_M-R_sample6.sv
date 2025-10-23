module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Intermediate signals for 2-to-1 multiplexers
    wire ab_00, ab_01, ab_10, ab_11;

    // Implement 2-to-1 multiplexers
    assign ab_00 = c | d;  // For 'ab' = '00'
    assign ab_01 = 0;       // For 'ab' = '01', always '0'
    assign ab_10 = c;       // For 'ab' = '10', use 2-to-1 multiplexer logic
    assign ab_11 = c & d;  // For 'ab' = '11'

    // Assign intermediate signals to mux_in
    assign mux_in[0] = ab_00;
    assign mux_in[1] = ab_01;
    assign mux_in[2] = ab_11;
    assign mux_in[3] = ab_10;

endmodule
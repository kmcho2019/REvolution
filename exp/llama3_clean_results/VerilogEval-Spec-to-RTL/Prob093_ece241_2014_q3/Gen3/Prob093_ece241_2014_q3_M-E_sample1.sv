module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    // Generate the output for 'ab' = 10
    assign mux_in[2] = c & ~d;

    // Generate the output for 'ab' = 11
    assign mux_in[3] = c | d;

    // Assign the outputs for 'ab' = 00 and 'ab' = 01
    assign mux_in[0] = 0;
    assign mux_in[1] = 0;

endmodule
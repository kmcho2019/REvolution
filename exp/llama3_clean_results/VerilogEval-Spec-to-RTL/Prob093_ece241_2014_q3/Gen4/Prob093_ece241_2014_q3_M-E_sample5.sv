module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    // 'ab' = 00: Output is 0 when 'cd' is 00, and 1 when 'cd' is 01
    assign mux_in[0] = (c & ~d) | (~c & d);

    // 'ab' = 01: Output is always 0
    assign mux_in[1] = 0;

    // 'ab' = 11: Output is 1 when 'c' or 'd' is 1
    assign mux_in[3] = c | d;

    // 'ab' = 10: Output is 1 when 'c' is 1 and 'd' is 0
    assign mux_in[2] = c & ~d;

endmodule
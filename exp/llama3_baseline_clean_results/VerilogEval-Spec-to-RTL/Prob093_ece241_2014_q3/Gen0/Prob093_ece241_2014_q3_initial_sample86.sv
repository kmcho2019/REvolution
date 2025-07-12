module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For mux_in[0], when ab = 00, the output should be 1 when c or d is 1
    assign mux_in[0] = (c == 1 || d == 1) ? 1 : 0;

    // For mux_in[1], when ab = 01, the output should be 1 when c is 1 and d is 0
    assign mux_in[1] = (c == 1 && d == 0) ? 1 : 0;

    // For mux_in[2], when ab = 11, the output should be 1 when c or d is 1
    assign mux_in[2] = (c == 1 || d == 1) ? 1 : 0;

    // For mux_in[3], when ab = 10, the output should be 1 when c is 1 or d is 1
    assign mux_in[3] = (c == 1 || d == 1) ? 1 : 0;
endmodule
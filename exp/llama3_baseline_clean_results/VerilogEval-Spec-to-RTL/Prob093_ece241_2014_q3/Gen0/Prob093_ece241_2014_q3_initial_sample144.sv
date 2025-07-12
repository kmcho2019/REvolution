module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, we need (c == 1) or (c == 0 and d == 1)
    // For ab = 01, we need (c == 1 and d == 0)
    // For ab = 10, we need (c == 1 or d == 1)
    // For ab = 11, we need (c == 1)

    // Directly feeding the logic for each 'ab' condition into mux_in
    mux_in[0] = (c == 1) || (c == 0 && d == 1); // ab = 00
    mux_in[1] = (c == 1 && d == 0);             // ab = 01
    mux_in[2] = (c == 1);                       // ab = 11
    mux_in[3] = (c == 1 || d == 1);             // ab = 10
endmodule
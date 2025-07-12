module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // ab = 00: output = 0 (no matter what c and d are)
    assign mux_in[0] = 0;

    // ab = 01: output = 1 if c = 1, 0 if c = 0
    assign mux_in[1] = c;

    // ab = 10: output = 1 if c = 1, 0 if c = 0
    assign mux_in[2] = c;

    // ab = 11: output = 1 if d = 0 or c = 1, 0 if d = 1 and c = 0
    assign mux_in[3] = (d) ? c : 1;
endmodule
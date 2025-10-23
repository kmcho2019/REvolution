module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d;  // ab = 00
    assign mux_in[1] = ~d; // ab = 01, d' means not d
    assign mux_in[2] = c || d; // ab = 11, using || (OR) for c + d
    assign mux_in[3] = c || d; // ab = 10, same as ab = 11

endmodule
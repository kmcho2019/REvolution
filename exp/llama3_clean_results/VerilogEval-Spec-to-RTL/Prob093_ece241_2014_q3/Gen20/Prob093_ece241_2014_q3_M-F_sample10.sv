module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Assigning outputs for each ab combination
    assign mux_in[0] = (c)? d : d;  // ab = 00, output is d
    assign mux_in[1] = 1'b0;  // ab = 01, always 0
    assign mux_in[2] = (c)? 1'b1 : d;  // ab = 11, output is 1 when c=1, d when c=0
    assign mux_in[3] = (c)? 1'b1 : d;  // ab = 10, output is 1 when c=1, d when c=0

endmodule
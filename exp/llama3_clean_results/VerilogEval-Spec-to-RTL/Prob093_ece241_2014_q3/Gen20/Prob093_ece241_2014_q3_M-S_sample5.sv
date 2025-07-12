module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Assigning outputs for each ab combination
    assign mux_in[3] = c;  // ab = 10
    assign mux_in[2] = c;  // ab = 11
    assign mux_in[1] = 1'b0;  // ab = 01, always 0
    assign mux_in[0] = (c)? 1'b1 : d;  // ab = 00, select between '1' (when c=1) and 'd' (when c=0)

endmodule
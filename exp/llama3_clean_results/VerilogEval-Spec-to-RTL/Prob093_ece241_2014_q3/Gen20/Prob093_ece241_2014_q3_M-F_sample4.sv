module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Assigning outputs for each ab combination based on the Karnaugh map
    assign mux_in[0] = (c) ? 1'b1 : d;  // ab = 00, output is '1' when 'c' is '1', 'd' when 'c' is '0'
    assign mux_in[1] = 1'b0;  // ab = 01, output is always '0'
    assign mux_in[2] = c;  // ab = 11, output is '1' when 'c' is '1'
    assign mux_in[3] = (c) ? 1'b1 : d;  // ab = 10, output is '1' when 'c' is '1', 'd' when 'c' is '0'

endmodule
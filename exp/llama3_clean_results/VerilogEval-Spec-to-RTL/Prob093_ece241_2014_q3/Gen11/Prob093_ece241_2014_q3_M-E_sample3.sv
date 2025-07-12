module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Create patterns for each 'ab' combination using 2-to-1 multiplexers
    assign mux_in[0] = (c == 1'b0)? d : 1'b0;  // For ab = 00, output is 'd' when 'c = 0'
    assign mux_in[1] = (c == 1'b1)? d : 1'b0;  // For ab = 01, output is 'd' when 'c = 1'
    assign mux_in[2] = c || d;                  // For ab = 11, output is 'c || d'
    assign mux_in[3] = c || d;                  // For ab = 10, output is 'c || d'
endmodule
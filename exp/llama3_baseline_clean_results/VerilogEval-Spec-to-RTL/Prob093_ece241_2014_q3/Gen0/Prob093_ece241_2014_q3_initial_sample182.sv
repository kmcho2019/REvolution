module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    // For ab = 00, output depends on 'c' and 'd'
    // For ab = 01, output is always 0
    // For ab = 11, output is 'c' when 'd' is 0 and 'd' when 'c' is 1
    // For ab = 10, output is 'c'
    
    // 2-to-1 multiplexer for ab = 00
    assign mux_in[0] = (d) ? 1'b1 : c;
    
    // For ab = 01, output is always 0
    assign mux_in[1] = 1'b0;
    
    // 2-to-1 multiplexer for ab = 11
    assign mux_in[2] = (c) ? d : c;
    
    // For ab = 10, output is 'c'
    assign mux_in[3] = c;
endmodule
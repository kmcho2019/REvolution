module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    // mux_in[0] (ab = 00) is always 0 for cd = 00 and 01, so it's just 0
    assign mux_in[0] = 0;
    
    // mux_in[1] (ab = 01) depends on 'c', so use a 2-to-1 multiplexer with 'd' as select
    assign mux_in[1] = (d) ? 0 : (c) ? 1 : 0;
    
    // mux_in[2] (ab = 11) depends on 'd', so use a 2-to-1 multiplexer with 'c' as select
    assign mux_in[2] = (c) ? 1 : (d) ? 1 : 1;
    
    // mux_in[3] (ab = 10) is always 1 for cd = 10 and 11, so it's just 'c'
    assign mux_in[3] = (c) ? 1 : (d) ? 1 : 0;
endmodule
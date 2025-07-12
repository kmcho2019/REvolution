module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    // For ab = 00, cd = 00 -> 0, cd = 01 -> 0, cd = 11 -> 1, cd = 10 -> 1
    assign mux_in[0] = (c && d) || (!c && d);
    
    // For ab = 01, cd = 00 -> 0, cd = 01 -> 1, cd = 11 -> 0, cd = 10 -> 0
    assign mux_in[1] = (c && !d) && (!c && !d);
    
    // This is actually not correct - it should be cd = 01
    assign mux_in[1] = c && !d;
    
    // For ab = 11, cd = 00 -> 0, cd = 01 -> 0, cd = 11 -> 1, cd = 10 -> 1
    assign mux_in[2] = (c && d) || (!c && d);
    
    // For ab = 10, cd = 00 -> 1, cd = 01 -> 0, cd = 11 -> 1, cd = 10 -> 1
    assign mux_in[3] = (!c && d) || (c && d) || (!c && !d);
    
    // This is actually not correct - it should be cd = 10 or cd = 11
    assign mux_in[3] = (!c && d) || (c && d);
endmodule
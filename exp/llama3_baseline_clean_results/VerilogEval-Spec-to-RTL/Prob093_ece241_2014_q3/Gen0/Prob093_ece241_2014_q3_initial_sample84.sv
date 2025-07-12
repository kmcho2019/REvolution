module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    // Using 2-to-1 multiplexers to generate the values for mux_in[0] and mux_in[2]
    // For mux_in[0], it should be 0 when c=0 and d=0, and 1 when c=1 and d=0
    assign mux_in[0] = (c && !d) ? 1 : 0;
    
    // Using a 2-to-1 multiplexer for mux_in[1] and mux_in[3]
    // For mux_in[1], it should be 0 when c=0 and d=0, and 0 when c=1 and d=0
    assign mux_in[1] = 0;
    
    // For mux_in[2], it should be 0 when c=0 and d=0, and 1 when c=1 and d=1
    assign mux_in[2] = (c && d) ? 1 : 0;
    
    // For mux_in[3], it should be 1 when c=0 and d=0, and 1 when c=1 and d=0 or c=1 and d=1
    assign mux_in[3] = (c && (d || !d)) || (!c && !d) ? 1 : 0;
endmodule
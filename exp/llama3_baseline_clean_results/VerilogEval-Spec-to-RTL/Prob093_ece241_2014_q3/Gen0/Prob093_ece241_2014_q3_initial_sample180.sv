module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    wire temp0, temp1;
    
    // Implementing the logic for cd = 00 and cd = 01
    // For ab = 00, 01, and 10, the output is the same, so we can directly assign
    // For ab = 11, cd = 11 gives 1 and cd = 01 gives 0, so we need a multiplexer
    assign mux_in[0] = 0;  // For ab = 00
    assign mux_in[1] = 0;  // For ab = 01
    assign mux_in[2] = d;  // For ab = 11, select between cd = 11 and cd = 01
    assign mux_in[3] = c;  // For ab = 10, select between cd = 11 and cd = 10
    
endmodule
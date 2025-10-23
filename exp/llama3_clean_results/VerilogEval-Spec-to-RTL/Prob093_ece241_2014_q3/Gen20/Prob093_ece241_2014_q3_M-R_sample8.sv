module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, select between '1' and 'd' based on 'c'
    assign mux_in[0] = (c) ? 1'b1 : d;
    
    // For ab = 01, assign '0' when 'c' is '0' or 'd' is '1', and 'c' when 'c' is '1' and 'd' is '0'
    assign mux_in[1] = (c && !d) ? 1'b1 : 1'b0;
    
    // For ab = 11, directly assign 'c'
    assign mux_in[2] = c;
    
    // For ab = 10, select between '1' and 'd' based on 'c'
    assign mux_in[3] = (c) ? 1'b1 : d;

endmodule
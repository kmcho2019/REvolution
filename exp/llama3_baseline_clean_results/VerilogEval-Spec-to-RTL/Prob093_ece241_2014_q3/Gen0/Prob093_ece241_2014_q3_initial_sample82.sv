module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    // Generate the required inputs for the 4-to-1 multiplexer
    // mux_in[0] corresponds to ab = 00
    // mux_in[1] corresponds to ab = 01
    // mux_in[2] corresponds to ab = 11
    // mux_in[3] corresponds to ab = 10
    
    // For ab = 00, we need 0
    assign mux_in[0] = 0;
    
    // For ab = 01, we need 0
    assign mux_in[1] = 0;
    
    // For ab = 11, we need a 2-to-1 mux with c as select and d as inputs
    // The other input of the mux is 1 (from K-map when c=1, d=1)
    assign mux_in[2] = (c) ? d : 1;
    
    // For ab = 10, we need a 2-to-1 mux with c as select and d as inputs
    // The other input of the mux is 1 (from K-map when c=1, d=0)
    assign mux_in[3] = (c) ? d : 1;
endmodule
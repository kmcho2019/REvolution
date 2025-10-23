module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    // For ab = 00, the input can be d when c is 0, otherwise 0
    assign mux_in[0] = ~c ? d : 0;
    
    // For ab = 01, the input is always 0
    assign mux_in[1] = 0;
    
    // For ab = 11, the input can be c when d is 1, otherwise d
    assign mux_in[2] = d ? c : d;
    
    // For ab = 10, the input is always d
    assign mux_in[3] = d;
endmodule
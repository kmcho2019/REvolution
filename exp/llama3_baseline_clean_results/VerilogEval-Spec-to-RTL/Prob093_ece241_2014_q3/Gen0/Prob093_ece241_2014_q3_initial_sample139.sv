module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    // Derive the inputs to the 4-to-1 multiplexer
    wire mux_in_0, mux_in_1, mux_in_2, mux_in_3;
    
    // For ab = 00
    assign mux_in_0 = (c == 0 && d == 0) ? 0 : 1;
    
    // For ab = 01
    assign mux_in_1 = 0;
    
    // For ab = 11
    assign mux_in_2 = (c == 1 && d == 1) ? 1 : ((c == 1 && d == 0) ? 1 : 0);
    
    // For ab = 10
    assign mux_in_3 = (c == 1 && d == 0) ? 1 : ((c == 1 && d == 1) ? 1 : 0);
    
    // Assign the derived inputs to the output
    assign mux_in = {mux_in_3, mux_in_2, mux_in_1, mux_in_0};
endmodule
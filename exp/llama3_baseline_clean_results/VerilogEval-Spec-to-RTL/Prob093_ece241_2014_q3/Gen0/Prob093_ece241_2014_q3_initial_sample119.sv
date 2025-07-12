module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;
    
    assign mux_in[0] = 1'b0;  // When ab = 00, output is always 0
    assign mux_in[1] = 1'b0;  // When ab = 01, output is always 0
    assign mux_in[2] = d;    // When ab = 11, output is d
    assign mux_in[3] = d;    // When ab = 10, output is d

endmodule
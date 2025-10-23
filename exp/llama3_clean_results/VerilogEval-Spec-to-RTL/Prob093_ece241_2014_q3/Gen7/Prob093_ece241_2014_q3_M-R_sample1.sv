module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is 1 only when d is high and c is low
    assign mux_in[0] = d && !c;
    
    // For ab = 01, output is always 0
    assign mux_in[1] = 1'b0;
    
    // For ab = 11, output is 1 when d is high (regardless of c)
    assign mux_in[2] = d;
    
    // For ab = 10, output is also 1 when d is high (regardless of c)
    assign mux_in[3] = d;
endmodule
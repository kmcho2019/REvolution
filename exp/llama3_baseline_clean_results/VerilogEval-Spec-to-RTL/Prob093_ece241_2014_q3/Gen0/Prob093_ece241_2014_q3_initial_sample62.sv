module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Drive the input of the 4-to-1 multiplexer
    // mux_in[0] corresponds to ab = 00
    assign mux_in[0] = 1'b0;
    
    // mux_in[1] corresponds to ab = 01
    assign mux_in[1] = 1'b0;
    
    // mux_in[2] corresponds to ab = 11
    // Use a 2-to-1 multiplexer to generate the input
    // If c = 0, then output = 0; if c = 1, then output = d
    assign mux_in[2] = (c) ? d : 1'b0;
    
    // mux_in[3] corresponds to ab = 10
    // Use a 2-to-1 multiplexer to generate the input
    // If d = 0, then output = c; if d = 1, then output = c
    assign mux_in[3] = (d) ? c : c;
endmodule
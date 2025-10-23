module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Generate the control signals for the 2-to-1 multiplexers
    assign mux_in[0] = d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c;
    assign mux_in[3] = d;

endmodule
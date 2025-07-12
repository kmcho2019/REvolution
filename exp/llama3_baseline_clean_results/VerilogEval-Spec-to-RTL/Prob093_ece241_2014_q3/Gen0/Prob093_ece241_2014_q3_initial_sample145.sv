module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implement the logic for each 'ab' value using 2-to-1 multiplexers
    assign mux_in[0] = (c) ? 1'b1 : (d) ? 1'b0 : 1'b0; // ab = 00
    assign mux_in[1] = 1'b0; // ab = 01
    assign mux_in[2] = (c) ? d : 1'b0; // ab = 11
    assign mux_in[3] = (c) ? (d) ? 1'b0 : 1'b1 : (d) ? 1'b1 : 1'b0; // ab = 10, using XOR
endmodule
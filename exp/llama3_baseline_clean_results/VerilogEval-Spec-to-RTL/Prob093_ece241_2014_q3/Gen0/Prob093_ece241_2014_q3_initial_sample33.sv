module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = c ? d : 1'b1;  // For ab = 00
    assign mux_in[1] = 1'b0;  // For ab = 01
    assign mux_in[2] = c ? d : 1'b0;  // For ab = 11
    assign mux_in[3] = d ? 1'b1 : c;  // For ab = 10

endmodule
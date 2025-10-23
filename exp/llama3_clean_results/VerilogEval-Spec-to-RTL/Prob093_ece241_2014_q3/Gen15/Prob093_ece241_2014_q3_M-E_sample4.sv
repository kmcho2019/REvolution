module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = (d ? 1'b0 : c);
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = (c ? d : 1'b1);
    assign mux_in[3] = (d ? 1'b0 : c);
endmodule
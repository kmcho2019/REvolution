module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = (c || (!c && d)) ? 1'b1 : 1'b0;
    assign mux_in[1] = (!c && d) ? 1'b1 : 1'b0;
    assign mux_in[2] = (c && d) ? 1'b1 : 1'b0;
    assign mux_in[3] = c ? 1'b1 : 1'b0;
endmodule
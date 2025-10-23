module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[3] = c;
    assign mux_in[2] = (d) ? c : 1'b1;
    assign mux_in[1] = (c) ? 1'b0 : d;
    assign mux_in[0] = (c) ? 1'b0 : d;
endmodule
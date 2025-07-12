module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = d ? d : 0;
    assign mux_in[1] = 0;
    assign mux_in[2] = c ? d : 0;
    assign mux_in[3] = c ? 1 : d;

endmodule
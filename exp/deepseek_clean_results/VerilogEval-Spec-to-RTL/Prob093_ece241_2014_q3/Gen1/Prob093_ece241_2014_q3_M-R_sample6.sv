module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = 1 when c=1, else d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] = always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c AND d
    assign mux_in[2] = c & d;

    // mux_in[3] = when d=1 output c, else 1
    assign mux_in[3] = d ? c : 1'b1;

endmodule
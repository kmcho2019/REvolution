module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] = d ? 1 : c;
    assign mux_in[0] = d ? 1'b1 : c;

    // mux_in[1] = 0;
    assign mux_in[1] = 1'b0;

    // mux_in[2] = d ? c : 0;
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3] = d ? c : 1;
    assign mux_in[3] = d ? c : 1'b1;

endmodule
module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);
    // not_d implemented as mux2: select d, inputs 1 and 0
    wire not_d = d ? 1'b0 : 1'b1;

    // mux_in[0] = c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? d : 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = c ? 1 : not_d
    assign mux_in[3] = c ? 1'b1 : not_d;

endmodule
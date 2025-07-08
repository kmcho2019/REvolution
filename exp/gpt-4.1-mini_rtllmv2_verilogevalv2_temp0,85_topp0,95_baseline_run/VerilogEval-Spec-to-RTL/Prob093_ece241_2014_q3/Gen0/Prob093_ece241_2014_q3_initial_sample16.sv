module TopModule(
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);

    // Implement ~d using a 2-to-1 mux: select=d, input0=1, input1=0
    wire not_d;
    assign not_d = d ? 1'b0 : 1'b1;

    // mux_in[0] = c ? 1 : d  -> mux with select=c, input0=d, input1=1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? d : 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = c ? 1 : ~d (not_d)
    assign mux_in[3] = c ? 1'b1 : not_d;

endmodule
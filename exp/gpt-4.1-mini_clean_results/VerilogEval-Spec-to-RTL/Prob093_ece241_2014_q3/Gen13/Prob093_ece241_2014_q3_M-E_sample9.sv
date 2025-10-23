module TopModule (
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);
    // Implement n_d = NOT d using 2-to-1 mux
    wire n_d;
    assign n_d = d ? 1'b0 : 1'b1;  // NOT d via mux

    // mux_in[0] = f0 = c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] = f1 = constant 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = f2 = c ? d : 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = f3 = c ? 1 : n_d
    assign mux_in[3] = c ? 1'b1 : n_d;

endmodule
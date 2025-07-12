module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: Implemented as c OR d using 2-to-1 mux
    assign mux_in[0] = d ? 1'b1 : c;

    // ab=01: always 0
    assign mux_in[1] = 1'b0;

    // ab=11: directly connect to c
    assign mux_in[2] = c;

    // ab=10: select between 1 and c based on d
    assign mux_in[3] = d ? c : 1'b1;

endmodule
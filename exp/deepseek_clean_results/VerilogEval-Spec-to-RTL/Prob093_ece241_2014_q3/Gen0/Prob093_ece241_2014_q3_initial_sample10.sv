module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = d
    assign mux_in[0] = d;

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c
    assign mux_in[2] = c;

    // mux_in[3] = ~d implemented with 2-to-1 mux
    // When d=0, output 1; when d=1, output 0
    assign mux_in[3] = d ? 1'b0 : 1'b1;

endmodule
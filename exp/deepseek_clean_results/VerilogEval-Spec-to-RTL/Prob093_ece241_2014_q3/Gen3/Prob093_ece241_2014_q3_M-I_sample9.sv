module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0]: c OR d (correct implementation)
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: constant 0 (correct)
    assign mux_in[1] = 1'b0;

    // mux_in[2]: c AND d (correct)
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3]: c OR NOT d
    // When d=0, output 1; when d=1, output c
    assign mux_in[3] = d ? c : 1'b1;

endmodule
module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0]: 1 when c or d is 1 (OR function)
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: Always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: c AND d
    assign mux_in[2] = c & d;

    // mux_in[3]: NOT d OR c
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule
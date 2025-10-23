module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0]: 1 when c=1 or d=1 but not both (XOR)
    wire mux0_sel;
    assign mux0_sel = c ^ d;
    assign mux_in[0] = mux0_sel ? d : c;

    // mux_in[1]: Always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: c AND d
    assign mux_in[2] = c & d;

    // mux_in[3]: 1 when c=d or d=0
    assign mux_in[3] = c ? d : 1'b1;

endmodule
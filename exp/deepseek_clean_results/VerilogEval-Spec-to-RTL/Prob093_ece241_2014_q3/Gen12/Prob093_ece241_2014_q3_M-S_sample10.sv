module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = ~(c & ~d);  // 0 only when cd=10
    assign mux_in[1] = 1'b0;       // always 0
    assign mux_in[2] = ~(c ^ d);   // XNOR: 1 when cd=00,11
    assign mux_in[3] = ~d;         // 0 only when d=1 (matches cd=01 case)

endmodule
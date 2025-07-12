module TopModule(
    input  a,       // selector bit a (not used inside but required by interface)
    input  b,       // selector bit b (not used inside but required by interface)
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Implement NOT d using 2-to-1 mux (ternary operator)
    wire not_d = d ? 1'b0 : 1'b1;

    // mux_in[0] for ab=00: f00 = mux2(c, d, 1)
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01: f01 = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: f11 = mux2(c, 0, d)
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] for ab=10: f10 = mux2(c, not_d, 1)
    assign mux_in[3] = c ? 1'b1 : not_d;
endmodule
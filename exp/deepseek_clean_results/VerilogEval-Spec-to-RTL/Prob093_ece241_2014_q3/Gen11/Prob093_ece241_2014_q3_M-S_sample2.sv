module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = c | d;       // 0 only when cd=00
    assign mux_in[1] = 1'b0;        // always 0
    assign mux_in[2] = ~(c ^ d);    // 1 when c == d
    assign mux_in[3] = ~(~c & d);   // 0 only when cd=01

endmodule
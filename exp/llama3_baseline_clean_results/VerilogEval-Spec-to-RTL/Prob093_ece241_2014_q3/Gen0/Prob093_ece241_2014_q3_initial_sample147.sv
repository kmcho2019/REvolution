module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = 0; // Direct connection for ab = 00
    assign mux_in[1] = 0; // Direct connection for ab = 01
    assign mux_in[2] = c; // Output for ab = 11
    assign mux_in[3] = c; // Output for ab = 10

endmodule
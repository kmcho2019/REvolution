module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = ~d; // d' for ab = 00
    assign mux_in[1] = ~d; // d' for ab = 01
    assign mux_in[2] = ~d; // d' for ab = 11 (not necessary, but following K-map for 2-1 mux input to 4-1 mux)
    assign mux_in[3] = d;  // d  for ab = 10

endmodule
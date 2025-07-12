module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Output for ab = 00
assign mux_in[0] = (d)? 1 : c;

// Output for ab = 01
assign mux_in[1] = (c)? 0 : 0;

// Output for ab = 11
assign mux_in[2] = (d)? 1 : 0;

// Output for ab = 10
assign mux_in[3] = (c)? 1 : 1;

endmodule
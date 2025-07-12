module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For cd = 00 (d'c'), we need a 2-to-1 mux to select 1 only for ab = 10
// But since we have ab = 11 as 0, we can directly use 'b' to select
assign mux_in[0] = d ? 0 : (c ? 0 : 1); // d'c'

// For cd = 01, the output should be 1 for ab = 00 and 0 for others
assign mux_in[1] = (d ? 0 : 1) & (c ? 1 : 0); // d'c

// For cd = 11, the output should be 1 for ab = 00, ab = 10, and ab = 11
assign mux_in[2] = d & c; // dc

// For cd = 10, the output should be 1 for ab = 00 and ab = 10, and 0 for ab = 01 and ab = 11
assign mux_in[3] = (d ? 0 : 1) & (c ? 1 : 0); // dc'

endmodule
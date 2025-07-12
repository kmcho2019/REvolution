module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

// Implement not d = MUX(d, 1, 0)
wire not_d = (d == 1'b0) ? 1'b1 : 1'b0;

// mux_in[0] = mux(d, c, 1) = (d==0)? c : 1
wire mux_in_0 = (d == 1'b0) ? c : 1'b1;

// mux_in[1] = 0
wire mux_in_1 = 1'b0;

// mux_in[2] = mux(c, 0, d) = (c==0)? 0 : d
wire mux_in_2 = (c == 1'b0) ? 1'b0 : d;

// mux_in[3] = mux(c, not_d, 1) = (c==0)? not_d : 1
wire mux_in_3 = (c == 1'b0) ? not_d : 1'b1;

assign mux_in = {mux_in_3, mux_in_2, mux_in_1, mux_in_0};

endmodule
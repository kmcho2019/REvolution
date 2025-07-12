module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For ab = 00, the output is '1' when cd = 10 and '0' otherwise
assign mux_in[0] = (c && d) ? 1'b1 : 1'b0;

// For ab = 01, the output is '0' for all cd
assign mux_in[1] = 1'b0;

// For ab = 11, the output is '1' when cd = 01 or cd = 11
assign mux_in[2] = (~c && d) || (c && d) ? 1'b1 : 1'b0;

// For ab = 10, the output is '1' when cd = 00 or cd = 10 or cd = 11
assign mux_in[3] = (~c && ~d) || (c && d) || (c && ~d) ? 1'b1 : 1'b0;

endmodule
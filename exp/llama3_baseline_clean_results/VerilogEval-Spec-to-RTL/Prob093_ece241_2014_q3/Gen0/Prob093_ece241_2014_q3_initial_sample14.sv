module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Generate output for cd = 01 and cd = 11 using one 2-to-1 multiplexer
wire out_01_11;
assign out_01_11 = (c & d) | (~c & d);

// Generate output for cd = 10 using another 2-to-1 multiplexer
wire out_10;
assign out_10 = c & (~d);

// Generate output for cd = 00 using a single wire
wire out_00;
assign out_00 = 1'b0;

// Connect the outputs to the 4-to-1 multiplexer
assign mux_in[0] = out_00;
assign mux_in[1] = 1'b0;
assign mux_in[2] = out_01_11;
assign mux_in[3] = out_10;

endmodule
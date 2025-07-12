module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Assign mux_in[0] and mux_in[1] directly
assign mux_in[0] = 0;
assign mux_in[1] = 0;

// Use a 2-to-1 multiplexer for mux_in[2]
assign mux_in[2] = (c == 1) ? d : 0;

// Use a 2-to-1 multiplexer for mux_in[3]
assign mux_in[3] = (c == 1) ? d : 1;

endmodule
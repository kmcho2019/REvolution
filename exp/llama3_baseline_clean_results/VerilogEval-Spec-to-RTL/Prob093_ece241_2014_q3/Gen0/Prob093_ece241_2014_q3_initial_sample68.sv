module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For ab = 00, output is always 0
assign mux_in[0] = 0;

// For ab = 01, output is always 0
assign mux_in[1] = 0;

// For ab = 11, output depends on c and d
// In this case, it's 1 when both c and d are 1
assign mux_in[2] = c && d;

// For ab = 10, output depends on c and d
// It's 1 when c is 1 and d is 0, or when both c and d are 0
assign mux_in[3] = (c && ~d) || (~c && ~d);

endmodule
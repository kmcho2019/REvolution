module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

// Implementing the Karnaugh map using 2-to-1 multiplexers and a 4-to-1 multiplexer
// We notice that for ab = 00 and ab = 01, the output depends directly on c and d
// For ab = 10 and ab = 11, the output can also be derived directly from c and d

// For ab = 00, the output is always 0 when c is 0, and 1 when c is 1 and d is 1
assign mux_in[0] = c & d;

// For ab = 01, the output is always 0
assign mux_in[1] = 1'b0;

// For ab = 11, the output is 1 when c is 1 or d is 1
assign mux_in[2] = c | d;

// For ab = 10, the output is 1
assign mux_in[3] = 1'b1;

endmodule
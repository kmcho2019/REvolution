module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Implementing the Karnaugh map
assign mux_in[0] = 0; // For ab = 00, output is always 0
assign mux_in[1] = 0; // For ab = 01, output is always 0
assign mux_in[2] = (c & d); // For ab = 11, output depends on c and d
assign mux_in[3] = c; // For ab = 10, output depends on c

endmodule
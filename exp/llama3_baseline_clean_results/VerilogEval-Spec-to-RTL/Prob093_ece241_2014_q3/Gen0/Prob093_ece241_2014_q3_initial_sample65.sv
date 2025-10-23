module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Implementing the logic using 2-to-1 multiplexers
// We need to generate the four input signals for the 4-to-1 multiplexer
// Each signal corresponds to a combination of 'a' and 'b' (00, 01, 11, 10)

// Signal for ab = 00 (mux_in[0])
// From the Karnaugh map, when ab = 00, the output is 0 for cd = 00, and 1 for cd = 10
// This can be implemented using a single 2-to-1 multiplexer with c and d as inputs and d as the selector
assign mux_in[0] = (d) ? 1 : 0;

// Signal for ab = 01 (mux_in[1])
// From the Karnaugh map, when ab = 01, the output is 0 for all combinations of cd
assign mux_in[1] = 0;

// Signal for ab = 11 (mux_in[2])
// From the Karnaugh map, when ab = 11, the output is 1 for cd = 11, and 0 for cd = 01
// This can be implemented using a single 2-to-1 multiplexer with c and d as inputs and c as the selector
assign mux_in[2] = (c) ? d : 0;

// Signal for ab = 10 (mux_in[3])
// From the Karnaugh map, when ab = 10, the output is 1 for cd = 10 and cd = 11, and 0 for cd = 00 and cd = 01
// This can be implemented using a single 2-to-1 multiplexer with d and c as inputs and d as the selector
assign mux_in[3] = (d) ? 1 : c;

endmodule
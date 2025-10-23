module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Assigning direct values from the Karnaugh map where applicable
assign mux_in[0] = 0; // For ab = 00
assign mux_in[1] = 0; // For ab = 01

// Implementing logic for ab = 11
assign mux_in[2] = (d) ? 1 : 0; // Using 'd' directly as it matches the pattern

// Implementing logic for ab = 10, noticing it's actually equivalent to just 'c' or 'd' being 1
assign mux_in[3] = (c || d) ? 1 : 0;

endmodule
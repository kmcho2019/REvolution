module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Determine if selection is valid (c < 4)
wire valid_sel = ~|c[3:2];  // NOR of upper 2 bits

// Create the mux selection - use c[1:0] when valid, force to 4 (invalid) otherwise
wire [2:0] mux_sel = valid_sel ? {1'b0, c[1:0]} : 3'b100;

// 5:1 mux (4 valid cases + 1 invalid case that outputs 'f')
assign q = (mux_sel == 2'b00) ? b :
           (mux_sel == 2'b01) ? e :
           (mux_sel == 2'b10) ? a :
           (mux_sel == 2'b11) ? d :
           4'b1111;  // default to 'f' for invalid cases

endmodule
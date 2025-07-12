module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Check if c >= 4 (upper bits are not zero)
wire invalid_sel = |c[3:2];

// 4:1 mux for valid cases (c < 4)
wire [3:0] mux_out = 
    (c[1:0] == 2'b00) ? b :
    (c[1:0] == 2'b01) ? e :
    (c[1:0] == 2'b10) ? a : d;

// Final output - mux output when valid, 'f' otherwise
assign q = invalid_sel ? 4'hf : mux_out;

endmodule
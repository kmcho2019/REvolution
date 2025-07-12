module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_ab, and_cd;
assign and_ab = a & b;
assign and_cd = c & d;

// First MUX selects between and_ab and and_cd based on a control signal
// For simplicity, let's use (a | c) as the control signal
wire mux_out;
assign mux_out = (a | c) ? and_cd : and_ab;

// Second MUX selects between mux_out and its inversion
assign out = mux_out;
assign out_n = ~mux_out;

endmodule
module TopModule(
    input a,
    input b,
    input c,
    output out
);

wire sel;
wire mux_out;

assign sel = a;
assign mux_out = (a) ? 1'b1 : (b | c);
assign out = mux_out;

endmodule
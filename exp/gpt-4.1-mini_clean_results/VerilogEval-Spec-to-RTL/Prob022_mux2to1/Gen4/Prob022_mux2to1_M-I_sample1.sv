module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Using AND-OR structure for mux to potentially reduce dynamic switching
wire sel_n;
assign sel_n = ~sel;

assign out = (a & sel_n) | (b & sel);

endmodule
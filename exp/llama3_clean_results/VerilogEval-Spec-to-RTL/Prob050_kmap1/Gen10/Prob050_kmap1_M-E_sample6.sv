// A novel implementation using a multiplexer and a logic gate
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Use a multiplexer to select between different inputs based on a and b
wire sel = a | b;
wire mux_out;

// Use the multiplexer to select between c and 1 based on the value of sel
assign mux_out = sel ? 1 : c;

// Use a simple logic gate to combine the selected input with c
assign out = mux_out | c;

endmodule
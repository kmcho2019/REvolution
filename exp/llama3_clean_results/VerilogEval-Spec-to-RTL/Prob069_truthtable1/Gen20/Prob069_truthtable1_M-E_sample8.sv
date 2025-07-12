module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Multiplexer to select between x1 and x2
wire mux_out;
assign mux_out = (x3)? x1 : x2;

// OR gate to combine the output of the multiplexer with x2 when x3 is 0
assign f = (x3)? mux_out : (x2 | mux_out);

endmodule
module TopModule(
    input  in,
    output out
);

// Using a multiplexer to implement a NOT gate
// The select line is tied to 1 to always select the inverted input
wire not_in; // Inverted version of the input
assign not_in = ~in;
mux2to1 mux_instance(.i0(in),.i1(not_in),.s(1'b1),.out(out));

endmodule

// Definition of the 2-to-1 multiplexer
module mux2to1(
    input  i0,
    input  i1,
    input  s,
    output out
);
assign out = (s == 1'b0)? i0 : i1;
endmodule
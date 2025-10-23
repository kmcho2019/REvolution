// Novel architectural solution using multiplexers and logic gates.
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Internal wires for the multiplexer selection and output.
wire sel;
wire mux_out;

// Use 'a' as the select line for the multiplexer.
assign sel = a;

// The multiplexer selects between '1' (when a=1) and the result of 'b | c' (when a=0).
assign mux_out = (sel) ? 1'b1 : (b | c);

// The final output is the result of the multiplexer, which directly corresponds to the Karnaugh map.
assign out = mux_out;

endmodule
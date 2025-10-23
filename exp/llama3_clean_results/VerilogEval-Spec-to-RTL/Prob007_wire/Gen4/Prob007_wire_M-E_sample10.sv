module TopModule(
    input  in,  // Input signal
    output out   // Output signal, selected by the multiplexer
);

// Instantiate a 2-to-1 multiplexer
mux2to1 u_mux (
    .A1(1'b0),  // Dummy input, not used
    .A0(in),    // Input signal to be passed through
    .S(1'b0),   // Select line, fixed to select A0
    .Y(out)     // Output of the multiplexer
);

endmodule

// Definition of the 2-to-1 multiplexer module used above
module mux2to1(
    input A1,  // First input to the multiplexer
    input A0,  // Second input to the multiplexer
    input S,   // Select line
    output Y   // Output of the multiplexer
);

// Multiplexer implementation: a simple conditional assignment
assign Y = (S) ? A1 : A0;

endmodule
module TopModule(
    input  in,
    output out
);
    
    // Internal wire for the multiplexer output
    wire mux_out;
    
    // Instantiate a 2-to-1 multiplexer
    // Since we only have one input, we'll tie the second input to 0
    // and the select line to 0, so it always selects the first input (in)
    assign mux_out = (1'b0) ? 1'b0 : in;
    
    // Assign the multiplexer output to the module output
    assign out = mux_out;

endmodule
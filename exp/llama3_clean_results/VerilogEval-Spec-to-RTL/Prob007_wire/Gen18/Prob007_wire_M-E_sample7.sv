module TopModule(
    input  in,
    output out
);
    
    // Internal wire to connect MUX output to out
    wire mux_out;
    
    // 2-to-1 Multiplexer implementation
    // Since we only have one input, we'll use the same input for both MUX inputs
    // and fix the select signal to always choose the first input
    assign mux_out = in; // Directly assigning in to mux_out, simulating MUX behavior
    
    // Assign MUX output to out
    assign out = mux_out;

endmodule
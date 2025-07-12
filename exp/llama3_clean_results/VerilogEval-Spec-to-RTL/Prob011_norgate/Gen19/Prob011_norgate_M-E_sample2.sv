module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    // Using a multiplexer to implement the NOR gate
    // The multiplexer selects the output based on the inputs
    // When both inputs are 0, the output is 1; otherwise, it's 0
    assign out = ~(a | b);  // Direct NOR implementation for comparison
    
    // Alternative implementation using a multiplexer
    // This is conceptually simpler but might not be more efficient in practice
    logic mux_out;  // Output of the multiplexer
    assign mux_out = (a == 1'b0 && b == 1'b0) ? 1'b1 : 1'b0;
    assign out = mux_out;  // Assign the multiplexer output to the final output
endmodule
module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
(* max_freq = "1000.0" *) 

always @(posedge clk) begin
    // For a basic D flip-flop, the implementation remains straightforward.
    // Consider adding a reset condition if the design requires it.
    q <= d;
end

// Although not necessary for this simple module, consider adding a comment
// or a header to describe the module's purpose, inputs, and outputs for clarity.

endmodule
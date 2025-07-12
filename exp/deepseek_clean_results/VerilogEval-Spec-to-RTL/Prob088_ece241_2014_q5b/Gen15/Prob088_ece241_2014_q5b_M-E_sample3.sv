module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single flip-flop representing complement mode (state B)
    reg complement_mode;

    // Next state logic (combinational)
    wire enter_complement = x & ~complement_mode;

    // Output logic (XOR of mode and input)
    assign z = complement_mode ^ x;

    // State register updates (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A (not in complement mode)
            complement_mode <= 1'b0;
        end else if (enter_complement) begin
            // Enter complement mode on first x=1
            complement_mode <= 1'b1;
        end
        // Once in complement mode, stay there forever
    end

endmodule
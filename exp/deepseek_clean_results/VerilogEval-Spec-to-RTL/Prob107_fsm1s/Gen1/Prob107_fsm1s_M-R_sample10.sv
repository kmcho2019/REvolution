module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    wire state;
    reg state_reg;

    // Next state logic (combinational)
    assign state = reset ? 1'b0 :  // Reset to state B (0)
                  (state_reg ? (in ? 1'b1 : 1'b0) :  // Current state A
                              (in ? 1'b0 : 1'b1));   // Current state B

    // State register (sequential)
    always @(posedge clk) begin
        state_reg <= state;
    end

    // Output logic (Moore)
    assign out = ~state_reg;  // out=1 when in state B (0), out=0 when in state A (1)

endmodule
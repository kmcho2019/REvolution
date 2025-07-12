module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg state; // 0 for state A, 1 for state B
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronously reset to state B
        state <= 1'b1;
    end else begin
        // Synchronously update state based on current state and input
        case (state)
            1'b0: state <= in? 1'b0 : 1'b1; // State A
            1'b1: state <= in? 1'b1 : 1'b0; // State B
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

// Determine output based on current state
assign out = state;

endmodule
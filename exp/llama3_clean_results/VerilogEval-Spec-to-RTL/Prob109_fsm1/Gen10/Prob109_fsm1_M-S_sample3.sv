module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal representing the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        // Update state based on current state and input
        case (state)
            1'b0: state <= in ? 1'b0 : 1'b1; // State A
            1'b1: state <= in ? 1'b1 : 1'b0; // State B
        endcase
    end
end

// Out is directly derived from the state in this implementation
assign out = state;

endmodule
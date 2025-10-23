module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg current_state;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Reset to state B
    end else begin
        case (current_state)
            1'b1: begin // State B
                if (!in) begin
                    current_state <= 1'b0; // Transition to state A on input 0
                end
            end
            1'b0: begin // State A
                if (!in) begin
                    current_state <= 1'b1; // Transition to state B on input 0
                end
            end
        endcase
    end
end

always @(*) begin
    out = current_state; // Output the current state
end

endmodule
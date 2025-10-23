module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 1-bit state variable
reg [0:0] next_state; // 1-bit next state variable

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        1'b0: begin // State A
            if (in) begin
                next_state = 1'b0; // Stay in state A
            end else begin
                next_state = 1'b1; // Transition to state B
            end
        end
        1'b1: begin // State B
            if (in) begin
                next_state = 1'b1; // Stay in state B
            end else begin
                next_state = 1'b0; // Transition to state A
            end
        end
        default: next_state = 1'b1; // Default to state B
    endcase
end

assign out = state; // Output is the current state

endmodule
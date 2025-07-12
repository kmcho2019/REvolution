module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state; // Using 2 bits for 2 states (A and B)
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b10; // Reset to state B
    end else begin
        case (state)
            2'b10: begin // State B
                if (!in) begin
                    state <= 2'b01; // Transition to state A
                end else begin
                    state <= 2'b10; // Stay in state B
                end
            end
            2'b01: begin // State A
                if (!in) begin
                    state <= 2'b10; // Transition to state B
                end else begin
                    state <= 2'b01; // Stay in state A
                end
            end
            default: state <= 2'b10; // Default to state B
        endcase
    end
end

assign out = (state == 2'b10) ? 1'b1 : 1'b0; // Output based on current state

endmodule
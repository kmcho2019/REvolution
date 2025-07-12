module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state; // 0: IDLE, 1: SEEN_1, 2: SEEN_10

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 0; // Reset to IDLE state
    end else begin
        case(state)
            0: begin // IDLE state
                if (x) begin
                    state <= 1; // Transition to SEEN_1 state if x is "1"
                end
            end
            1: begin // SEEN_1 state
                if (!x) begin
                    state <= 2; // Transition to SEEN_10 state if x is "0"
                end else begin
                    // Stay in SEEN_1 if x is still "1", waiting for "0"
                    state <= 1;
                end
            end
            2: begin // SEEN_10 state
                if (x) begin
                    z <= 1'b1; // Assert z if sequence "101" is detected
                    state <= 1; // Move to SEEN_1 for potential overlap
                end else begin
                    state <= 0; // Reset to IDLE if sequence not matched
                end
            end
            default: state <= 0; // Default to IDLE state
        endcase
    end
end

always @(posedge clk) begin
    if (state != 2 || !x) begin
        z <= 1'b0; // Deassert z when not in SEEN_10 state with x="1"
    end
end

endmodule
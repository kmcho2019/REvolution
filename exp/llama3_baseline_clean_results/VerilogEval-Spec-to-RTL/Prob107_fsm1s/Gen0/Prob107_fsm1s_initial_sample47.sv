module TopModule(
    input         clk,
    input         reset,
    input         in,
    output        out
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // State B
            if (!in) begin
                next_state = 2'b01; // Transition to A
            end else begin
                next_state = 2'b00; // Stay in B
            end
            out = 1'b1; // Output for state B
        end
        2'b01: begin // State A
            if (!in) begin
                next_state = 2'b00; // Transition to B
            end else begin
                next_state = 2'b01; // Stay in A
            end
            out = 1'b0; // Output for state A
        end
        default: begin
            next_state = 2'b00; // Default to state B
            out = 1'b1; // Default output
        end
    endcase
end

endmodule
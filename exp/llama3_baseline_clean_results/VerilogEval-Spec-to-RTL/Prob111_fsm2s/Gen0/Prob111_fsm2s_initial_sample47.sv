module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state;  // Using a single bit for two states: OFF (0) and ON (1)
reg [0:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;  // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @* begin
    case (state)
        0: begin  // OFF state
            if (j == 1) begin
                next_state = 1;  // Transition to ON
            end else begin
                next_state = 0;  // Stay in OFF
            end
        end
        1: begin  // ON state
            if (k == 1) begin
                next_state = 0;  // Transition to OFF
            end else begin
                next_state = 1;  // Stay in ON
            end
        end
        default: next_state = 0;  // Should never happen for a 2-state FSM
    endcase
end

assign out = state;  // Output is directly determined by the current state

endmodule
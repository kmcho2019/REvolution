module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // 0: OFF, 1: ON
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        0: begin // OFF state
            if (j) begin
                next_state = 1; // Transition to ON
            end else begin
                next_state = 0; // Stay in OFF
            end
        end
        1: begin // ON state
            if (k) begin
                next_state = 0; // Transition to OFF
            end else begin
                next_state = 1; // Stay in ON
            end
        end
        default: next_state = 0; // Invalid state, reset to OFF
    endcase
end

assign out = state; // Output is determined by the current state

endmodule
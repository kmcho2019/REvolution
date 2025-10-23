module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg [0:0] state; // 0 - OFF, 1 - ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON state
                end else begin
                    state <= 0; // Stay in OFF state
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF state
                end else begin
                    state <= 1; // Stay in ON state
                end
            end
            default: state <= 0; // Default to OFF state for invalid state
        endcase
    end
end

always @(*) begin
    case (state)
        0: out = 0; // Output for OFF state
        1: out = 1; // Output for ON state
        default: out = 0; // Default output for invalid state
    endcase
end

endmodule
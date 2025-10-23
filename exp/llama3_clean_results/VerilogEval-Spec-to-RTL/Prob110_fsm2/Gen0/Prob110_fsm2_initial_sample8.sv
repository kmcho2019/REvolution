module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: // OFF state
                if (j) begin
                    state <= 1; // Transition to ON state
                end else begin
                    state <= 0; // Stay in OFF state
                end
            1: // ON state
                if (k) begin
                    state <= 0; // Transition to OFF state
                end else begin
                    state <= 1; // Stay in ON state
                end
            default:
                state <= 0; // Default to OFF state
        endcase
    end
end

always @(state) begin
    case (state)
        0: out <= 0; // Output 0 when in OFF state
        1: out <= 1; // Output 1 when in ON state
        default:
            out <= 0; // Default output to 0
    endcase
end

endmodule
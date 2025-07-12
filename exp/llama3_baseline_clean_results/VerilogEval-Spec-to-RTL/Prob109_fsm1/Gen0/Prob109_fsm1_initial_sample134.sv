module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

reg [1:0] curr_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        curr_state <= 2'b01; // Reset to state B
    end else begin
        case (curr_state)
            2'b00: // State A
                if (~in) begin
                    curr_state <= 2'b01; // Transition to state B
                end else begin
                    curr_state <= 2'b00; // Stay in state A
                end
            2'b01: // State B
                if (in) begin
                    curr_state <= 2'b01; // Stay in state B
                end else begin
                    curr_state <= 2'b00; // Transition to state A
                end
            default:
                curr_state <= 2'b01; // Default to state B
        endcase
    end
end

always @(*) begin
    case (curr_state)
        2'b00: // State A
            out = 0;
        2'b01: // State B
            out = 1;
        default:
            out = 1; // Default to output 1
    endcase
end

endmodule
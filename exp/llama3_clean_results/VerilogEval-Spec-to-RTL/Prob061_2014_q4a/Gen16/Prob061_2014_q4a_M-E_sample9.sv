// Novel solution using a state machine
module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg [1:0] state; // State machine states: IDLE (2'b00), LOAD (2'b01), SHIFT (2'b10)

always @(posedge clk) begin
    case(state)
        2'b00: // IDLE state
            begin
                if (L) begin
                    state <= 2'b01; // Transition to LOAD state
                    Q <= R;
                end else if (E) begin
                    state <= 2'b10; // Transition to SHIFT state
                    Q <= w;
                end
            end
        2'b01: // LOAD state
            begin
                state <= 2'b00; // Transition back to IDLE state
            end
        2'b10: // SHIFT state
            begin
                state <= 2'b00; // Transition back to IDLE state
            end
        default:
            state <= 2'b00; // Default to IDLE state
    endcase
end

endmodule
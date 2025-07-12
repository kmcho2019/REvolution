module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite State Machine states
parameter IDLE = 2'b00, HIGH = 2'b01, FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE; // Reset state to idle
        data_out <= 0; // Reset output
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= HIGH; // Transition to high state if data_in is high
                end else begin
                    state <= IDLE; // Stay in idle if data_in remains low
                end
                data_out <= 0; // Output is low in idle state
            end
            HIGH: begin
                if (data_in) begin
                    state <= HIGH; // Remain in high state if data_in stays high
                end else begin
                    state <= FALLING; // Transition to falling state if data_in goes low
                end
                data_out <= 0; // Output is low in high state
            end
            FALLING: begin
                state <= IDLE; // Transition back to idle state
                if (data_in) begin
                    data_out <= 0; // Output is low if data_in unexpectedly goes high
                end else begin
                    data_out <= 1; // Output is high if a pulse is detected
                end
            end
            default: begin
                state <= IDLE; // Default to idle state for any unexpected state
                data_out <= 0; // Reset output in default case
            end
        endcase
    end
end

endmodule
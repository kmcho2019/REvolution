module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state
parameter IDLE = 2'b00; // Initial state
parameter RISING = 2'b01; // State after rising edge
parameter FALLING = 2'b10; // State after falling edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset to initial state
        data_out <= 1'b0; // Reset data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING; // Transition to RISING state on rising edge
                end
                data_out <= 1'b0; // No pulse detected
            end
            RISING: begin
                if (~data_in) begin
                    state <= FALLING; // Transition to FALLING state on falling edge
                end
                data_out <= 1'b0; // Not the end of a pulse
            end
            FALLING: begin
                state <= IDLE; // Return to IDLE state
                if (~data_in) begin
                    data_out <= 1'b1; // Pulse detected, set data_out to 1
                end else begin
                    data_out <= 1'b0; // Not a pulse, set data_out to 0
                end
            end
            default: begin
                state <= IDLE; // Default to IDLE state
                data_out <= 1'b0; // No pulse detected
            end
        endcase
    end
end

endmodule
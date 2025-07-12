module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine state register
parameter IDLE = 2'b00, PULSE_HIGH = 2'b01, PULSE_FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset FSM to IDLE state
        data_out <= 0; // Reset output to zero
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= PULSE_HIGH; // Transition to PULSE_HIGH state on 0 to 1
                end
                data_out <= 0; // Reset data_out to 0 in IDLE state
            end
            PULSE_HIGH: begin
                if (data_in == 1'b1) begin
                    state <= PULSE_HIGH; // Stay in PULSE_HIGH state if data_in remains 1
                end else if (data_in == 1'b0) begin
                    state <= PULSE_FALLING; // Transition to PULSE_FALLING state on 1 to 0
                end
                data_out <= 0; // Reset data_out to 0 in PULSE_HIGH state
            end
            PULSE_FALLING: begin
                state <= IDLE; // Transition back to IDLE state
                data_out <= 1; // Set data_out to 1 in PULSE_FALLING state
            end
            default: begin
                state <= IDLE; // Default to IDLE for any other state
                data_out <= 0; // Reset data_out to 0 for any other state
            end
        endcase
    end
end

endmodule
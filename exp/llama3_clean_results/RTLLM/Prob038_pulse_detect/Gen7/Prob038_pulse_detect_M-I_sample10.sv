module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine state register
reg pulse_detected; // Flag to indicate pulse detection
parameter IDLE = 2'b00, RISING = 2'b01, FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset FSM to IDLE state
        pulse_detected <= 0; // Reset pulse detection flag
        data_out <= 0; // Reset output to zero
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= RISING; // Transition to RISING state on 0 to 1
                end else begin
                    state <= IDLE; // Stay in IDLE if data_in remains 0
                end
                pulse_detected <= 0; // Reset pulse detection flag
            end
            RISING: begin
                if (data_in == 1'b1) begin
                    state <= RISING; // Stay in RISING state if data_in remains 1
                end else begin
                    state <= FALLING; // Transition to FALLING state on 1 to 0
                    pulse_detected <= 1; // Set pulse detection flag
                end
            end
            FALLING: begin
                state <= IDLE; // Transition back to IDLE state
                if (pulse_detected == 1'b1) begin
                    data_out <= 1; // Set data_out to 1 if pulse detected
                end else begin
                    data_out <= 0; // Reset data_out to 0 if no pulse detected
                end
                pulse_detected <= 0; // Reset pulse detection flag
            end
        endcase
    end
end

endmodule
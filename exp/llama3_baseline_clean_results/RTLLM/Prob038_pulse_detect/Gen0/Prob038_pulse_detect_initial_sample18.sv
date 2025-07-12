module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state
parameter IDLE = 2'b00, RISING = 2'b01, FALLING = 2'b10; // Define the states

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Reset the state register to the initial state
        data_out <= 0; // Reset the output signal to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Check if the input signal has risen
                    state <= RISING; // Transition to the RISING state
                    data_out <= 0; // Set the output signal to 0
                end else begin
                    state <= IDLE; // Stay in the IDLE state
                    data_out <= 0; // Set the output signal to 0
                end
            end
            RISING: begin
                if (data_in) begin // Check if the input signal is still high
                    state <= RISING; // Stay in the RISING state
                    data_out <= 0; // Set the output signal to 0
                end else begin
                    state <= FALLING; // Transition to the FALLING state
                    data_out <= 1; // Set the output signal to 1 (end of pulse)
                end
            end
            FALLING: begin
                state <= IDLE; // Transition back to the IDLE state
                data_out <= 0; // Set the output signal to 0
            end
            default: begin
                state <= IDLE; // Default state is IDLE
                data_out <= 0; // Set the output signal to 0
            end
        endcase
    end
end

endmodule
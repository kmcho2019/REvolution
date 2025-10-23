module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to represent the current state
parameter IDLE = 2'b00; // Initial state
parameter PULSE_START = 2'b01; // State after detecting a rising edge
parameter PULSE_END = 2'b10; // State after detecting a falling edge after a rising edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Set the state to the initial state
        data_out <= 1'b0; // Set the output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // If data_in is 1, transition to PULSE_START state
                    state <= PULSE_START;
                end else begin // If data_in is 0, stay in the IDLE state
                    state <= IDLE;
                end
                data_out <= 1'b0; // Set the output to 0
            end
            PULSE_START: begin
                if (~data_in) begin // If data_in is 0, transition to PULSE_END state
                    state <= PULSE_END;
                end else begin // If data_in is 1, stay in the PULSE_START state
                    state <= PULSE_START;
                end
                data_out <= 1'b0; // Set the output to 0
            end
            PULSE_END: begin
                state <= IDLE; // Transition back to the IDLE state
                data_out <= 1'b1; // Set the output to 1 to indicate the end of a pulse
            end
        endcase
    end
end

endmodule
module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to represent the three states
parameter IDLE = 2'b00; // Initial state
parameter PULSE_START = 2'b01; // State after rising edge of data_in
parameter PULSE_END = 2'b10; // State after falling edge of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Reset state to IDLE
        data_out <= 1'b0; // Reset data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Check for rising edge of data_in
                    state <= PULSE_START; // Transition to PULSE_START state
                    data_out <= 1'b0; // data_out remains 0
                end else begin
                    state <= IDLE; // Remain in IDLE state
                    data_out <= 1'b0; // data_out remains 0
                end
            end
            PULSE_START: begin
                if (~data_in) begin // Check for falling edge of data_in
                    state <= PULSE_END; // Transition to PULSE_END state
                    data_out <= 1'b0; // data_out remains 0
                end else begin
                    state <= PULSE_START; // Remain in PULSE_START state
                    data_out <= 1'b0; // data_out remains 0
                end
            end
            PULSE_END: begin
                data_out <= 1'b1; // Set data_out to 1, indicating end of pulse
                state <= IDLE; // Transition back to IDLE state
            end
            default: begin
                state <= IDLE; // Default state is IDLE
                data_out <= 1'b0; // data_out remains 0
            end
        endcase
    end
end

endmodule
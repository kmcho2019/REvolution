module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // State register for FSM
reg prev_data_in; // Store previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0; // Reset state to initial
        data_out <= 0; // Reset output
        prev_data_in <= 0; // Reset previous data_in
    end else begin
        case (state)
            0: begin // Initial state
                if (data_in && !prev_data_in) begin // Rising edge
                    state <= 1; // Transition to rising edge detected state
                end
            end
            1: begin // Rising edge detected
                if (!data_in && prev_data_in) begin // Falling edge after rising edge
                    data_out <= 1; // Assert data_out to signal pulse
                    state <= 2; // Transition to falling edge detected state
                end
            end
            2: begin // Falling edge detected
                data_out <= 0; // Deassert data_out
                state <= 0; // Return to initial state
            end
            default: state <= 0; // Default to initial state
        endcase
        prev_data_in <= data_in; // Update previous data_in
    end
end

endmodule
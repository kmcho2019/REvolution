module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Store the previous state of data_in
reg [1:0] state; // 0 - Idle, 1 - Rising Edge Detected, 2 - Falling Edge Detected

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // Reset to idle state
        prev_data_in <= 0; // Reset previous data_in
        data_out <= 0; // Reset output
    end else begin
        case(state)
            0: begin // Idle state
                if (~data_in && prev_data_in) begin // Falling edge
                    data_out <= 1; // Pulse detected
                end else if (data_in && ~prev_data_in) begin // Rising edge
                    state <= 1; // Transition to rising edge detected state
                end
                prev_data_in <= data_in;
            end
            1: begin // Rising edge detected
                if (~data_in) begin // Falling edge
                    state <= 2; // Transition to falling edge detected state
                    data_out <= 1; // Pulse detected
                end
                prev_data_in <= data_in;
            end
            2: begin // Falling edge detected
                state <= 0; // Return to idle state
                prev_data_in <= data_in;
                data_out <= 0; // Reset output
            end
        endcase
    end
end

endmodule
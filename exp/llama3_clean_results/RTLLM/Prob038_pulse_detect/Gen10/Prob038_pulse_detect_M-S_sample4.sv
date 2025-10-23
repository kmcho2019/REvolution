module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Register to track the state of the pulse detection process

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Reset state to idle
        data_out <= 1'b0; // Reset output to 0
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data_in) begin
                    state <= 2'b01; // Transition to rising edge detected state
                end else begin
                    state <= 2'b00; // Stay in idle state
                end
            end
            2'b01: begin // Rising edge detected state
                if (data_in) begin
                    state <= 2'b01; // Stay in rising edge detected state
                end else begin
                    state <= 2'b10; // Transition to falling edge detected state
                    data_out <= 1'b1; // Set output to 1
                end
            end
            2'b10: begin // Falling edge detected state
                state <= 2'b00; // Transition to idle state
                data_out <= 1'b0; // Reset output to 0
            end
        endcase
    end
end

endmodule
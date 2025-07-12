module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite State Machine (FSM) state register
reg delayed_data_in; // Register to delay data_in by one cycle

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initialize state to IDLE
        data_out <= 1'b0;
        delayed_data_in <= 1'b0;
    end else begin
        // Delay data_in by one cycle
        delayed_data_in <= data_in;

        case (state)
            2'b00: // IDLE state
                if (data_in) begin // Transition to PULSE_STARTED state
                    state <= 2'b01;
                end
            2'b01: // PULSE_STARTED state
                if (!data_in && delayed_data_in) begin // Transition to PULSE_DETECTED state
                    state <= 2'b10;
                end else if (!data_in) begin // Transition back to IDLE state
                    state <= 2'b00;
                end
            2'b10: // PULSE_DETECTED state
                state <= 2'b00; // Transition back to IDLE state
        endcase

        // Set data_out based on the current state
        if (state == 2'b10) begin // PULSE_DETECTED state
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule
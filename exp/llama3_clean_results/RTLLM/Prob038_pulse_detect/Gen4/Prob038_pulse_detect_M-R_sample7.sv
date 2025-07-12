module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state
reg prev_data_in; // Register to store previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Idle state
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data_in) begin
                    state <= 2'b01; // Transition to pulse_start state
                end
                data_out <= 0;
            end
            2'b01: begin // Pulse_start state
                if (~data_in) begin
                    state <= 2'b10; // Transition to pulse_end state
                end
                data_out <= 0;
            end
            2'b10: begin // Pulse_end state
                data_out <= 1;
                state <= 2'b00; // Transition back to idle state
            end
        endcase
        prev_data_in <= data_in; // Update previous data_in value
    end
end

endmodule
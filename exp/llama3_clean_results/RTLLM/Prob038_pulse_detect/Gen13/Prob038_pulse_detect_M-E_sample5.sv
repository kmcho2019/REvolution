module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register (IDLE, RISING, FALLING, PULSE_DETECTED)
reg [1:0] counter; // 2-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initialize state to IDLE
        counter <= 2'b00; // Initialize counter to 0
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in) begin
                    state <= 2'b01; // Transition to RISING state
                    counter <= 2'b01; // Initialize counter to 1
                end
            end
            2'b01: begin // RISING state
                if (~data_in && counter == 2'b01) begin
                    state <= 2'b10; // Transition to FALLING state
                    counter <= 2'b10; // Increment counter
                end else if (~data_in) begin
                    state <= 2'b00; // Transition back to IDLE state
                    counter <= 2'b00; // Reset counter
                end else begin
                    counter <= counter + 1; // Increment counter
                end
            end
            2'b10: begin // FALLING state
                if (~data_in && counter == 2'b10) begin
                    state <= 2'b11; // Transition to PULSE_DETECTED state
                    data_out <= 1'b1; // Set data_out to 1
                end else if (data_in) begin
                    state <= 2'b00; // Transition back to IDLE state
                    counter <= 2'b00; // Reset counter
                end
            end
            2'b11: begin // PULSE_DETECTED state
                state <= 2'b00; // Transition back to IDLE state
                counter <= 2'b00; // Reset counter
                data_out <= 1'b0; // Reset data_out to 0
            end
        endcase
    end
end

endmodule
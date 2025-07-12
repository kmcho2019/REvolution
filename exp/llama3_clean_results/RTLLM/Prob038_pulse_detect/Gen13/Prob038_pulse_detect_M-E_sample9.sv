module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register
reg [1:0] status_counter; // 2-bit status counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initialize state to IDLE
        status_counter <= 2'b00; // Initialize status counter to 0
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in) begin
                    state <= 2'b01; // Transition to RISING state
                end
            end
            2'b01: begin // RISING state
                status_counter <= status_counter + 1; // Increment status counter
                if (~data_in) begin
                    state <= 2'b10; // Transition to PEAK state
                end
            end
            2'b10: begin // PEAK state
                if (status_counter > 0) begin
                    data_out <= 1'b1; // Set data_out to 1 if pulse detected
                end
                state <= 2'b11; // Transition to FALLING state
                status_counter <= 2'b00; // Reset status counter
            end
            2'b11: begin // FALLING state
                state <= 2'b00; // Transition back to IDLE state
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule
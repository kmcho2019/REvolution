module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register to track pulse detection process
reg prev_data_in; // Register to store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state: WAIT_FOR_RISING_EDGE
        prev_data_in <= 1'b0;
        data_out <= 1'b0;
    end else begin
        prev_data_in <= data_in;
        
        case (state)
            2'b00: begin // WAIT_FOR_RISING_EDGE
                if (data_in && !prev_data_in) begin
                    state <= 2'b01; // Transition to WAIT_FOR_FALLING_EDGE
                end
            end
            2'b01: begin // WAIT_FOR_FALLING_EDGE
                if (!data_in && prev_data_in) begin
                    state <= 2'b00; // Transition back to WAIT_FOR_RISING_EDGE
                    data_out <= 1'b1; // Output pulse signal
                end else if (data_in && prev_data_in) begin
                    state <= 2'b01; // Stay in WAIT_FOR_FALLING_EDGE
                end else if (!data_in && !prev_data_in) begin
                    state <= 2'b00; // Transition back to WAIT_FOR_RISING_EDGE
                end
            end
        endcase
        
        // Clock gating: Reset data_out to 0 when not in WAIT_FOR_FALLING_EDGE state
        if (state != 2'b01 || !data_in) begin
            data_out <= 1'b0;
        end
    end
end

endmodule
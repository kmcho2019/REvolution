module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to store previous value of data_in
reg [1:0] state; // 2-bit state register to track pulse detection process

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 0;
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        prev_data_in <= data_in; // Update previous data_in value
        case (state)
            0: begin // Initial state
                if (data_in) begin
                    state <= 1; // Transition to high state
                end else begin
                    state <= 0; // Stay in initial state
                end
                data_out <= 0;
            end
            1: begin // High state
                if (~data_in) begin
                    state <= 2; // Transition to falling edge state
                end else begin
                    state <= 1; // Stay in high state
                end
                data_out <= 0;
            end
            2: begin // Falling edge state
                state <= 0; // Transition back to initial state
                data_out <= 1; // Indicate pulse detection
            end
        endcase
    end
end

endmodule
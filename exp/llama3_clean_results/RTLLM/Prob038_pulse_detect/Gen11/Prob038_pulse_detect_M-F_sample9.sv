module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Register to store the current state
reg prev_data_in; // Register to store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state: idle
        prev_data_in <= 1'b0;
        data_out <= 1'b0;
    end else begin
        prev_data_in <= data_in;
        
        case (state)
            2'b00: begin // Idle state
                if (data_in && !prev_data_in) begin // 0 to 1 transition
                    state <= 2'b01; // Move to rising_edge state
                end
                data_out <= 1'b0;
            end
            
            2'b01: begin // Rising edge state
                if (data_in) begin // Check if data_in remains high
                    state <= 2'b10; // Move to falling_edge state
                end else begin
                    state <= 2'b00; // Return to idle state
                end
                data_out <= 1'b0;
            end
            
            2'b10: begin // Falling edge state
                if (!data_in && prev_data_in) begin // 1 to 0 transition
                    data_out <= 1'b1; // Output pulse signal
                end else begin
                    data_out <= 1'b0;
                end
                state <= 2'b00; // Return to idle state
            end
            
            default: begin
                state <= 2'b00;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule
module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Register to store the current state
reg [1:0] count; // Register to count the number of cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state: idle
        count <= 2'b00; // Initialize counter
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data_in) begin // 0 to 1 transition
                    state <= 2'b01; // Move to high state
                    count <= 2'b01; // Increment counter
                end
                data_out <= 1'b0;
            end
            
            2'b01: begin // High state
                if (data_in) begin // Check if data_in remains high
                    count <= count + 1; // Increment counter
                    if (count == 2'b10) begin // Check if two cycles have passed
                        state <= 2'b10; // Move to falling edge state
                    end
                end else begin
                    state <= 2'b00; // Return to idle state
                    count <= 2'b00; // Reset counter
                end
                data_out <= 1'b0;
            end
            
            2'b10: begin // Falling edge state
                if (!data_in) begin // 1 to 0 transition
                    data_out <= 1'b1; // Output pulse signal
                end else begin
                    data_out <= 1'b0;
                end
                state <= 2'b00; // Return to idle state
                count <= 2'b00; // Reset counter
            end
            
            default: begin
                state <= 2'b00;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule
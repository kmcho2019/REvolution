module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Register to store the current state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state: idle
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data_in) begin // 0 to 1 transition
                    state <= 2'b01; // Move to high state
                end else begin
                    state <= 2'b00; // Stay in idle state
                end
                data_out <= 1'b0;
            end
            
            2'b01: begin // High state
                if (!data_in) begin // 1 to 0 transition
                    state <= 2'b10; // Move to falling edge state
                end else begin
                    state <= 2'b01; // Stay in high state
                end
                data_out <= 1'b0;
            end
            
            2'b10: begin // Falling edge state
                state <= 2'b00; // Return to idle state
                data_out <= 1'b1; // Output pulse signal
            end
            
            default: begin
                state <= 2'b00;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule
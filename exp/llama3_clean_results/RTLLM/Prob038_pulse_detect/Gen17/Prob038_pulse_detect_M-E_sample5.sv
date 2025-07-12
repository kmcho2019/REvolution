module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: idle, 1: rising, 2: falling
reg [1:0] counter; // Counter to track the number of cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state: idle
        counter <= 2'b00;
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data_in) begin
                    state <= 2'b01; // Transition to rising state
                    counter <= 2'b01; // Initialize counter
                end
                data_out <= 1'b0;
            end
            
            2'b01: begin // Rising state
                if (counter == 2'b11) begin
                    if (data_in) begin
                        state <= 2'b01; // Stay in rising if data_in remains high
                    end else begin
                        state <= 2'b10; // Transition to falling state if data_in falls
                    end
                end else begin
                    counter <= counter + 1'b1; // Increment counter
                end
                data_out <= 1'b0;
            end
            
            2'b10: begin // Falling state
                if (!data_in) begin
                    data_out <= 1'b1; // Output pulse signal
                    state <= 2'b00; // Reset to idle state
                    counter <= 2'b00; // Reset counter
                end else begin
                    state <= 2'b00; // Reset to idle if data_in doesn't fall
                    counter <= 2'b00; // Reset counter
                    data_out <= 1'b0;
                end
            end
            
            default: begin
                state <= 2'b00;
                counter <= 2'b00;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule
module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Register to store the current state
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
                    state <= 2'b01; // Move to pulse state
                    counter <= 2'b01; // Initialize counter
                end
                data_out <= 1'b0;
            end
            
            2'b01: begin // Pulse state
                if (!data_in) begin
                    state <= 2'b00; // Move back to idle state
                    counter <= 2'b00; // Reset counter
                end else if (counter == 2'b11) begin
                    state <= 2'b00; // Move back to idle state
                    counter <= 2'b00; // Reset counter
                    data_out <= 1'b1; // Output pulse signal
                end else begin
                    counter <= counter + 1'b1; // Increment counter
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
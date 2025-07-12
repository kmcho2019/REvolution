module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] counter; // Counter to track the length of the pulse
reg prev_data_in; // Store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0; // Reset counter
        data_out <= 0; // Reset output
        prev_data_in <= 0; // Reset previous data_in
    end else begin
        if (prev_data_in == 1'b0 && data_in == 1'b1) begin // Rising edge detected
            counter <= 1; // Initialize counter for high pulse
        end else if (prev_data_in == 1'b1 && data_in == 1'b1) begin // Still in high pulse
            counter <= counter + 1; // Increment counter
        end else if (prev_data_in == 1'b1 && data_in == 1'b0) begin // Falling edge detected
            if (counter >= 1) begin // Check if pulse was of desired length
                data_out <= 1; // Pulse detected, set output high
            end else begin
                data_out <= 0; // Not a pulse, reset output
            end
            counter <= 0; // Reset counter
        end else begin // No pulse or still in low state
            counter <= 0; // Reset counter
            data_out <= 0; // Reset output
        end
        prev_data_in <= data_in; // Update previous data_in
    end
end

endmodule
module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Store previous value of data_in for edge detection
reg pulse_detected; // Flag to indicate pulse detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0; // Reset output
        pulse_detected <= 0; // Reset pulse detected flag
        prev_data_in <= 0; // Reset previous data_in
    end else begin
        if (data_in && !prev_data_in) begin // Rising edge
            pulse_detected <= 1; // Set pulse detected flag
        end else if (!data_in && prev_data_in && pulse_detected) begin // Falling edge after rising edge
            data_out <= 1; // Assert data_out
            pulse_detected <= 0; // Reset pulse detected flag
        end else if (!data_in) begin // Reset data_out when data_in is low
            data_out <= 0;
        end
        prev_data_in <= data_in; // Update previous data_in
    end
end

endmodule
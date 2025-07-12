module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] count; // Counter to track high signal duration
reg pulse_detected; // Flag to indicate pulse detection
reg prev_data_in; // Store previous value of data_in for edge detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0; // Reset counter
        pulse_detected <= 0; // Reset pulse detected flag
        data_out <= 0; // Reset output
        prev_data_in <= 0; // Reset previous data_in
    end else begin
        prev_data_in <= data_in; // Update previous data_in
        
        if (data_in) begin
            count <= count + 1; // Increment counter if data_in is high
            if (count == 1 && prev_data_in == 0) begin // Check for rising edge and count equals 1
                pulse_detected <= 1; // Set pulse detected flag
            end else if (count > 1) begin // If count exceeds 1, reset flag
                pulse_detected <= 0;
            end
        end else begin
            count <= 0; // Reset counter if data_in is low
            if (prev_data_in == 1 && pulse_detected == 1) begin // Check if previous was high and pulse was detected
                data_out <= 1; // Assert data_out if valid pulse detected
                pulse_detected <= 0; // Reset pulse detected flag
            end else begin
                data_out <= 0; // Deassert data_out otherwise
            end
        end
    end
end

endmodule
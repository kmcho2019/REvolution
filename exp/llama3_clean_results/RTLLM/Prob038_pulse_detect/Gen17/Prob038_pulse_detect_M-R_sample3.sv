module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Store the previous value of data_in
reg pulse_detected; // Flag to indicate if a pulse has been detected

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data_in <= 0; // Reset previous data_in
        pulse_detected <= 0; // Reset pulse detection flag
    end else begin
        prev_data_in <= data_in; // Update previous data_in
        if (prev_data_in == 1'b1 && data_in == 1'b0) begin // Falling edge detected
            pulse_detected <= 1; // Pulse detected
        end else begin
            pulse_detected <= 0; // Reset pulse detection flag
        end
    end
end

// Combinational logic to set data_out based on pulse detection
assign data_out = pulse_detected && !data_in;

endmodule
module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to store the previous value of data_in
reg pulse_detected; // Register to indicate if a pulse has been detected

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 0;
        pulse_detected <= 0;
    end else begin
        prev_data_in <= data_in;
        if (data_in == 1'b1 && prev_data_in == 1'b0) begin // Rising edge detected
            pulse_detected <= 1'b1;
        end else if (data_in == 1'b0 && prev_data_in == 1'b1 && pulse_detected == 1'b1) begin // Falling edge detected after a rising edge
            pulse_detected <= 1'b0;
        end else begin
            pulse_detected <= 0;
        end
    end
end

assign data_out = (data_in == 1'b0 && prev_data_in == 1'b1 && pulse_detected == 1'b1); // Set data_out to 1 when a pulse is detected

endmodule
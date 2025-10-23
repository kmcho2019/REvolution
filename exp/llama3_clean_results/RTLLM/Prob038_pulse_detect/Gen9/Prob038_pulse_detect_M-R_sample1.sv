module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to store the previous value of data_in
reg [1:0] pulse_counter; // Counter to track clock cycles since start of pulse
reg pulse_detected; // Register to track whether a pulse has been detected

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 1'b0;
        pulse_counter <= 2'b00;
        pulse_detected <= 1'b0;
    end else begin
        prev_data_in <= data_in;
        
        if (data_in && !prev_data_in) begin // Rising edge detected
            pulse_counter <= 2'b01;
        end else if (!data_in && prev_data_in) begin // Falling edge detected
            if (pulse_counter == 2'b01) begin // Pulse detected
                pulse_detected <= 1'b1;
            end
            pulse_counter <= 2'b00;
        end else if (data_in && prev_data_in) begin // Data_in still high
            if (pulse_counter == 2'b01) begin
                pulse_counter <= pulse_counter + 1'b1;
            end
        end else if (!data_in && !prev_data_in) begin // Data_in still low
            pulse_counter <= 2'b00;
        end
        
        if (pulse_detected) begin
            pulse_detected <= 1'b0;
        end
    end
end

always @(*) begin
    data_out = pulse_detected;
end

endmodule
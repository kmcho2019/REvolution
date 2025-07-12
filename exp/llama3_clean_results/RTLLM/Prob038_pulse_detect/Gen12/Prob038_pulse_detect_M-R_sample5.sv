module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to store the previous value of data_in
reg rising_edge_detected; // Register to store the rising edge detection
reg [1:0] counter; // Counter to detect the pulse width

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 1'b0;
        rising_edge_detected <= 1'b0;
        counter <= 2'b00;
        data_out <= 1'b0;
    end else begin
        prev_data_in <= data_in;
        
        // Rising edge detection
        if (data_in && !prev_data_in) begin
            rising_edge_detected <= 1'b1;
            counter <= 2'b01;
        end else if (rising_edge_detected && !data_in) begin
            // Falling edge detection
            data_out <= 1'b1;
            rising_edge_detected <= 1'b0;
            counter <= 2'b00;
        end else if (rising_edge_detected && data_in) begin
            // Pulse width detection
            counter <= counter + 1;
            if (counter == 2'b10) begin
                rising_edge_detected <= 1'b0;
                counter <= 2'b00;
            end
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule
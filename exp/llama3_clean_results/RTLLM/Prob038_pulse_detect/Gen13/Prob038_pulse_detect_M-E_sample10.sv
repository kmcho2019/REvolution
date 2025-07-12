module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] counter; // Counter to track the duration of the high pulse
reg prev_data_in; // Register to store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        counter <= 0;
        prev_data_in <= 0;
    end else begin
        if (data_in) begin // If data_in is high
            counter <= counter + 1; // Increment the counter
        end else begin // If data_in is low
            if (prev_data_in && (counter == 1)) begin // Check if previous cycle was high and counter is 1
                data_out <= 1; // Set data_out to 1 if a valid pulse is detected
            end else begin
                data_out <= 0; // Otherwise, set data_out to 0
            end
            counter <= 0; // Reset the counter when data_in goes low
        end
        prev_data_in <= data_in; // Update the previous value of data_in
    end
end

endmodule
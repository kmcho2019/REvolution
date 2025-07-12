module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] counter; // Counter to track cycles after rising edge
reg prev_data_in; // Register to store previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0; // Reset counter
        prev_data_in <= 0; // Reset previous data_in
        data_out <= 0; // Reset output
    end else begin
        prev_data_in <= data_in; // Update previous data_in
        
        // Check for rising edge of data_in
        if (data_in && !prev_data_in) begin
            counter <= 1; // Start counting from 1
        end else if (data_in) begin
            counter <= counter + 1; // Increment counter if data_in remains high
        end else begin
            counter <= 0; // Reset counter if data_in goes low
        end
        
        // Assert data_out when counter reaches 2 (indicating a pulse)
        if (counter == 2 && !data_in) begin
            data_out <= 1; // Set data_out high
        end else begin
            data_out <= 0; // Reset data_out otherwise
        end
    end
end

endmodule
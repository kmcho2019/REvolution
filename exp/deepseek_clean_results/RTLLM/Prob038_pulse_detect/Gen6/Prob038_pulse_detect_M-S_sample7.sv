module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data;       // Stores previous input value
reg saw_rising_edge; // Flag for rising edge detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 1'b0;
        saw_rising_edge <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Detect rising edge (0->1)
        if (!prev_data && data_in) begin
            saw_rising_edge <= 1'b1;
        end
        
        // Detect falling edge (1->0) after rising edge
        data_out <= (prev_data && !data_in && saw_rising_edge);
        
        // Reset edge detection after pulse completes
        if (data_out) begin
            saw_rising_edge <= 1'b0;
        end
        
        // Update previous data
        prev_data <= data_in;
    end
end

endmodule
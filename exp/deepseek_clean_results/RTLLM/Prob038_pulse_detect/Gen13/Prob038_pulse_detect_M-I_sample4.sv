module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg data_in_reg;      // Registered input to reduce switching
reg [1:0] prev_data;  // Stores previous two samples

// Detect the 010 pattern (0->1->0 transition)
wire pulse_detected = (prev_data == 2'b10) && (data_in_reg == 1'b0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_in_reg <= 1'b0;
        prev_data <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        // Register input to reduce switching in the shift register
        data_in_reg <= data_in;
        
        // Shift in new data (using registered version)
        prev_data <= {prev_data[0], data_in_reg};
        
        // Registered output for clean timing
        data_out <= pulse_detected;
    end
end

endmodule
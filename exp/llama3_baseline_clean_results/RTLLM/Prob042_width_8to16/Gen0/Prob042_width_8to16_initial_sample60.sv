module width_8to16(
    input           clk,          // Clock signal
    input           rst_n,        // Active-low reset signal
    input           valid_in,    // Input signal indicating the validity of the input data
    input   [7:0]   data_in,      // 8-bit input data to be converted
    output          valid_out,   // Output signal indicating the validity of the output data
    output  [15:0]  data_out      // 16-bit output data resulting from the width conversion
);

reg [7:0]  data_lock;  // Register to store the first 8-bit data
reg        flag;       // Flag to indicate when the first data has been stored

// Generate valid_out and data_out signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;  // Reset valid_out to 0
        data_out  <= 16'd0;  // Reset data_out to 0
        flag      <= 1'b0;   // Reset flag to 0
        data_lock <= 8'd0;   // Reset data_lock to 0
    end else begin
        if (valid_in &&!flag) begin
            // Store the first valid data and set the flag
            data_lock <= data_in;
            flag      <= 1'b1;
            valid_out <= 1'b0;  // Not valid yet
        end else if (valid_in && flag) begin
            // Concatenate the stored data with the new data and generate valid_out and data_out
            data_out  <= {data_lock, data_in};
            valid_out <= 1'b1;  // Valid output
            flag      <= 1'b0;   // Reset flag
        end else begin
            valid_out <= 1'b0;  // Not valid
        end
    end
end

endmodule
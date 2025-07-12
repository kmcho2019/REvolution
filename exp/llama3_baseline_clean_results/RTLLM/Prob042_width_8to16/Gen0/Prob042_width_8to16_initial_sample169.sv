module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;  // Register to store the first received 8-bit data
reg flag;            // Flag to indicate whether we are waiting for the second valid data input

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        data_out <= 16'd0;  // Clear data_out register
        data_lock <= 8'd0;  // Clear data_lock register
        flag <= 1'b0;      // Reset flag to idle state
        valid_out <= 1'b0; // Reset valid_out signal
    end else if (valid_in) begin  // If input data is valid
        if (~flag) begin  // If we are in the idle state
            data_lock <= data_in;  // Store the first received 8-bit data
            flag <= 1'b1;          // Set flag to waiting state
        end else begin  // If we are in the waiting state
            data_out <= {data_lock, data_in};  // Concatenate the two 8-bit data to form a 16-bit output
            valid_out <= 1'b1;                   // Set valid_out signal to indicate valid output data
            flag <= 1'b0;                         // Reset flag to idle state
        end
    end else begin  // If input data is not valid
        valid_out <= 1'b0;  // Reset valid_out signal
    end
end

endmodule
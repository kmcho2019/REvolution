module width_8to16 (
    input               clk,          // Clock signal
    input               rst_n,        // Active-low reset signal
    input               valid_in,     // Input signal indicating the validity of the input data
    input      [7:0]     data_in,     // 8-bit input data to be converted
    output reg          valid_out,    // Output signal indicating the validity of the output data
    output reg [15:0]   data_out      // 16-bit output data resulting from the width conversion
);

reg [7:0] data_lock;  // Register to store the first valid input data
reg       flag;      // Flag signal to track the FSM state

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        valid_out <= 1'b0;
        data_out  <= 16'd0;
        data_lock <= 8'd0;
        flag      <= 1'b0;
    end else begin
        if (valid_in && !flag) begin
            // Store the first valid input data and set the flag
            data_lock <= data_in;
            flag      <= 1'b1;
        end else if (valid_in && flag) begin
            // Concatenate the stored data with the new input data and generate the output
            data_out  <= {data_lock, data_in};
            valid_out <= 1'b1;
            flag      <= 1'b0;  // Reset the flag
        end else if (!valid_in && flag) begin
            // Keep the flag active if no new valid input data arrives
            flag <= 1'b1;
        end else begin
            // Reset the valid output signal if no valid input data arrives
            valid_out <= 1'b0;
        end
    end
end

endmodule
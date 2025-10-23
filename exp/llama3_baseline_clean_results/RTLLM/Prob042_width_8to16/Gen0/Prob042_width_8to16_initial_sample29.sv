module width_8to16 (
    input        clk,           // Clock signal
    input        rst_n,         // Active-low reset signal
    input        valid_in,      // Input signal indicating the validity of the input data
    input  [7:0] data_in,       // 8-bit input data to be converted
    output       valid_out,     // Output signal indicating the validity of the output data
    output [15:0] data_out      // 16-bit output data resulting from the width conversion
);

reg [7:0] data_lock;            // Register to store the first arriving 8-bit data
reg        flag;                // Flag signal to track whether the first data input has arrived

// Initialize valid_out to 0
assign valid_out = (flag && valid_in);

// Update data_out register on the positive edge of the clock signal or the negative edge of the reset signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear data_out register on reset
        data_out <= 16'd0;
        // Clear flag signal on reset
        flag <= 1'b0;
        // Clear data_lock register on reset
        data_lock <= 8'd0;
    end else begin
        if (valid_in && !flag) begin
            // Store the first arriving 8-bit data in data_lock register
            data_lock <= data_in;
            // Set flag signal to indicate that the first data input has arrived
            flag <= 1'b1;
        end else if (valid_in && flag) begin
            // Concatenate the contents of data_lock register and data_in register to form a 16-bit output
            data_out <= {data_lock, data_in};
            // Clear flag signal to indicate that the output data has been generated
            flag <= 1'b0;
        end
    end
end

endmodule
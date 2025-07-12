module width_8to16 (
    input           clk,          // Clock signal
    input           rst_n,        // Active-low reset signal
    input           valid_in,     // Input signal indicating the validity of the input data
    input   [7:0]    data_in,      // 8-bit input data to be converted
    output          valid_out,    // Output signal indicating the validity of the output data
    output  [15:0]   data_out      // 16-bit output data resulting from the width conversion
);

reg     [7:0]    data_lock;       // Register to store the first arriving 8-bit data
reg             flag;            // Flag to track whether the first data has arrived
reg     [15:0]   data_out_reg;    // Register to store the 16-bit output data
reg             valid_out_reg;    // Register to store the validity of the output data

// Initialize the registers
initial begin
    data_lock = 8'b0;
    flag = 1'b0;
    data_out_reg = 16'b0;
    valid_out_reg = 1'b0;
end

// Update the registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the registers
        data_lock <= 8'b0;
        flag <= 1'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
    end else begin
        // Update the registers
        if (valid_in && flag) begin
            // If the input data is valid and the flag is active, concatenate the data_lock and data_in to form a 16-bit output
            data_out_reg <= {data_lock, data_in};
            valid_out_reg <= 1'b1;
            flag <= 1'b0;
        end else if (valid_in && !flag) begin
            // If the input data is valid and the flag is inactive, store the data_in in the data_lock register and set the flag
            data_lock <= data_in;
            flag <= 1'b1;
            valid_out_reg <= 1'b0;
        end else begin
            // If the input data is not valid, do not update the registers
            valid_out_reg <= 1'b0;
        end
    end
end

// Assign the output signals
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
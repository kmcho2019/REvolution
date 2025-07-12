module width_8to16 (
    input           clk,         // Clock signal
    input           rst_n,       // Active-low reset signal
    input           valid_in,    // Input signal indicating the validity of the input data
    input   [7:0]    data_in,     // 8-bit input data to be converted
    output          valid_out,   // Output signal indicating the validity of the output data
    output  [15:0]   data_out    // 16-bit output data resulting from the width conversion
);

reg     [7:0]    data_lock;     // Register to store the first valid input data
reg             flag;           // Flag signal to track the state of the module
reg             valid_out_reg;  // Register to store the valid_out signal
reg     [15:0]   data_out_reg;  // Register to store the data_out signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock     <= 8'd0;
        flag         <= 1'b0;
        valid_out_reg <= 1'b0;
        data_out_reg  <= 16'd0;
    end else begin
        if (valid_in && !flag) begin
            // Store the first valid input data and set the flag
            data_lock <= data_in;
            flag     <= 1'b1;
        end else if (valid_in && flag) begin
            // Concatenate the stored data with the new input data and set the output
            data_out_reg  <= {data_lock, data_in};
            valid_out_reg <= 1'b1;
            flag         <= 1'b0;
        end else begin
            // Reset the output and flag if there is no valid input data
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule
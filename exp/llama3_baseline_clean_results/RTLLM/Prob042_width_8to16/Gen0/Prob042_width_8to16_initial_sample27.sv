module width_8to16 (
    input         clk,        // Clock signal
    input         rst_n,      // Active-low reset signal
    input         valid_in,   // Input signal indicating the validity of the input data
    input  [7:0]  data_in,    // 8-bit input data to be converted
    output        valid_out,  // Output signal indicating the validity of the output data
    output [15:0] data_out    // 16-bit output data resulting from the width conversion
);

reg [7:0] data_lock;  // Register to store the first 8-bit data
reg        flag;      // Flag to track whether the first 8-bit data has been received
reg [15:0] data_out_reg;  // Register to store the 16-bit output data
reg        valid_out_reg;  // Register to store the validity of the output data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        data_lock <= 8'h0;
        flag <= 1'b0;
        data_out_reg <= 16'h0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (!flag) begin
            // Store the first 8-bit data and set the flag
            data_lock <= data_in;
            flag <= 1'b1;
        end else begin
            // Concatenate the two 8-bit data and reset the flag
            data_out_reg <= {data_lock, data_in};
            valid_out_reg <= 1'b1;
            flag <= 1'b0;
        end
    end else begin
        // If the input data is not valid, reset the output
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock; // Temporary register to hold the first 8-bit data
reg flag; // Flag to indicate if the first data has been stored
reg [15:0] data_out_reg; // Register to hold the 16-bit output data
reg valid_out_reg; // Register to hold the output validity signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset conditions
        data_out_reg <= 16'd0;
        valid_out_reg <= 1'b0;
        data_lock <= 8'd0;
        flag <= 1'b0;
    end else begin
        // Sequential logic
        if (valid_in && !flag) begin
            // Store the first valid data and set the flag
            data_lock <= data_in;
            flag <= 1'b1;
        end else if (valid_in && flag) begin
            // Concatenate the stored data with the new data and reset the flag
            data_out_reg <= {data_lock, data_in};
            valid_out_reg <= 1'b1;
            flag <= 1'b0;
        end else begin
            // If no valid data or only one valid data, do not update the output
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
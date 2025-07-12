module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock; // Register to hold the first 8-bit data
reg first_data_valid; // Flag to indicate if the first data is valid and stored
reg [15:0] data_out_reg; // Register for the 16-bit output data
reg valid_out_reg; // Register for the output validity signal

// Update the flag and data registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_data_valid <= 1'b0;
        data_lock <= 8'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            if (!first_data_valid) begin
                // Store the first input data and set the flag
                data_lock <= data_in;
                first_data_valid <= 1'b1;
            end else begin
                // Concatenate the stored data with the current input and update output
                data_out_reg <= {data_lock, data_in};
                valid_out_reg <= 1'b1;
                first_data_valid <= 1'b0; // Reset the flag for the next pair
            end
        end else begin
            // If input is not valid, do not update the output
            valid_out_reg <= 1'b0;
        end
    end
end

// Assign the output signals
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
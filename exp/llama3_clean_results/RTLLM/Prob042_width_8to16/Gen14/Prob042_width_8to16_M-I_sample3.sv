module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

// Registers to store the first valid input data and the concatenated output data
reg [7:0] data_lock_reg;
reg [15:0] data_out_reg;
reg valid_out_reg;
reg first_data_valid;

// Always block to update registers based on the input signals and clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Clear all registers
        data_lock_reg <= 8'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
        first_data_valid <= 1'b0;
    end else begin
        if (valid_in) begin
            if (!first_data_valid) begin
                // Store the first valid input data
                data_lock_reg <= data_in;
                first_data_valid <= 1'b1;
            end else begin
                // Concatenate the stored data with the new input data and set output valid
                data_out_reg <= {data_lock_reg, data_in};
                valid_out_reg <= 1'b1;
                first_data_valid <= 1'b0;
            end
        end else begin
            // If input data is not valid, reset the output valid signal
            valid_out_reg <= 1'b0;
        end
    end
end

// Assign output signals based on the registers
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
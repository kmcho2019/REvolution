module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

// Registers to store the incoming 8-bit data
reg [7:0] data_lock;
reg [7:0] data_in_reg;

// Flag to track the validity of the data stored in data_lock
reg valid_lock;

// Register to store the validity of the output data
reg valid_out_reg;

// Output data register
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers on active-low reset
        data_lock <= 8'd0;
        data_in_reg <= 8'd0;
        valid_lock <= 1'b0;
        valid_out_reg <= 1'b0;
        data_out_reg <= 16'd0;
    end
    else begin
        // Update logic for data_lock and valid_lock
        if (valid_in) begin
            if (!valid_lock) begin
                // Store the first valid data in data_lock and set valid_lock
                data_lock <= data_in;
                valid_lock <= 1'b1;
            end
            else begin
                // Store the second valid data in data_in_reg
                data_in_reg <= data_in;
                // Concatenate data_lock and data_in_reg to form the 16-bit output
                data_out_reg <= {data_lock, data_in_reg};
                // Assert valid_out_reg to indicate valid output data
                valid_out_reg <= 1'b1;
            end
        end
        else begin
            // If input data is not valid, do not update data_lock or valid_lock
            // But still need to consider the case where we are holding the output
            // Do nothing in this case, let the output hold its previous value
        end
        
        // Reset logic for data_lock, data_in_reg, valid_lock, and valid_out_reg
        if (valid_out_reg) begin
            // After one clock cycle, reset these registers for the next conversion
            data_lock <= 8'd0;
            data_in_reg <= 8'd0;
            valid_lock <= 1'b0;
            valid_out_reg <= 1'b0;
        end
    end
end

// Output assignments
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
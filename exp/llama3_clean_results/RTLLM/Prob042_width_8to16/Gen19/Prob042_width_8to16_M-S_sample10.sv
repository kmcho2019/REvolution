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
    else if (valid_in) begin
        if (!valid_lock) begin
            // Store the first valid data in data_lock and set valid_lock
            data_lock <= data_in;
            valid_lock <= 1'b1;
        end
        else begin
            // Store the second valid data in data_in_reg and concatenate with data_lock
            data_in_reg <= data_in;
            data_out_reg <= {data_lock, data_in_reg};
            valid_out_reg <= 1'b1;
            valid_lock <= 1'b0; // Reset valid_lock after generating output
        end
    end
    else if (valid_out_reg) begin
        // Reset registers after one clock cycle
        valid_out_reg <= 1'b0;
        data_out_reg <= 16'd0;
    end
end

// Output assignments
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
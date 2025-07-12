module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;  // Register to store the first arriving data
reg [7:0] data_in_reg;  // Register to store the second arriving data
reg             flag;  // Flag to track whether the first data has been stored
reg             valid_out_reg;  // Register to store the valid_out signal
reg [15:0] data_out_reg;  // Register to store the data_out signal

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset
        data_lock <= 8'd0;
        data_in_reg <= 8'd0;
        flag <= 1'b0;
        valid_out_reg <= 1'b0;
        data_out_reg <= 16'd0;
    end else begin
        if (valid_in && !flag) begin  // Store the first valid data
            data_lock <= data_in;
            flag <= 1'b1;
        end else if (valid_in && flag) begin  // Store the second valid data and generate output
            data_in_reg <= data_in;
            valid_out_reg <= 1'b1;
            data_out_reg <= {data_lock, data_in_reg};
            flag <= 1'b0;  // Reset flag for next pair of data
        end else begin
            valid_out_reg <= 1'b0;  // Reset valid_out if no valid data
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg        first_valid; // Flag to track if the first valid data has been received
reg        valid_out_reg; // Register for the valid_out signal
reg [15:0] data_out_reg; // Register for the data_out signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first      <= 8'd0;
        first_valid    <= 1'b0;
        valid_out_reg  <= 1'b0;
        data_out_reg   <= 16'd0;
    end
    else begin
        if (valid_in) begin
            if (!first_valid) begin
                data_first  <= data_in;
                first_valid <= 1'b1;
            end
            else begin
                data_out_reg   <= {data_first, data_in}; // Concatenate data
                valid_out_reg  <= 1'b1; // Assert valid_out
                first_valid    <= 1'b0; // Reset flag
            end
        end
        else if (first_valid) begin
            // No action needed; waiting for the next valid data input
        end
        else begin
            valid_out_reg  <= 1'b0; // Deassert valid_out if no valid input
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
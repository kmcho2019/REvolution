module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg [7:0] data_second; // Register to store the second 8-bit data input
reg        first_valid; // Flag to track if the first valid data has been received
reg [15:0] data_out_reg; // Register for the data_out signal
reg        valid_out_reg; // Register for the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first      <= 8'd0;
        data_second    <= 8'd0;
        first_valid    <= 1'b0;
        data_out_reg   <= 16'd0;
        valid_out_reg  <= 1'b0;
    end
    else begin
        if (valid_in) begin
            if (!first_valid) begin
                data_first  <= data_in;
                first_valid <= 1'b1;
            end
            else begin
                data_second <= data_in;
                data_out_reg <= {data_first, data_second}; // Update data_out register
                valid_out_reg <= 1'b1; // Assert valid_out register
                first_valid   <= 1'b0; // Reset first_valid flag
            end
        end
        else begin
            valid_out_reg <= 1'b0; // Deassert valid_out register if no valid input
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
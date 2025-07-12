module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_first;
reg valid_out_reg;
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first      <= 8'd0;
        valid_out_reg   <= 1'b0;
        data_out_reg   <= 16'd0;
    end
    else begin
        if (valid_in) begin
            if (data_first == 8'd0) begin
                // Store the first valid data
                data_first <= data_in;
            end
            else begin
                // Concatenate the stored first data with the new data
                data_out_reg <= {data_first, data_in};
                valid_out_reg <= 1'b1;
                // Reset the stored data for the next pair
                data_first <= 8'd0;
            end
        end
        else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule
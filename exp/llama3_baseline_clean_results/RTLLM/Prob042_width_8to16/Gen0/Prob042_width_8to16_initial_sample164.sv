module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg             flag;
reg     [7:0]   data_lock;
reg     [15:0]  data_out_reg;

assign valid_out = flag;
assign data_out  = data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        flag        <= 1'b0;
        data_lock   <= 8'd0;
        data_out_reg <= 16'd0;
    end else if (valid_in) begin
        if (!flag) begin
            // Store the first valid data
            data_lock   <= data_in;
            flag        <= 1'b1;
            data_out_reg <= 16'd0;
        end else begin
            // Concatenate the stored data with the new data
            data_out_reg <= {data_lock, data_in};
            flag        <= 1'b0;
        end
    end else begin
        // If input data is not valid, keep the flag and data_out_reg unchanged
        flag        <= flag;
        data_out_reg <= data_out_reg;
    end
end

endmodule
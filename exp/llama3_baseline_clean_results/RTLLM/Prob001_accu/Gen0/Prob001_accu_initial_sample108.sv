module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0]   data_sum;
reg [1:0]   count;
reg         valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_sum <= 10'd0;
        count    <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (count == 2'd3) begin
            data_sum <= data_sum + data_in;
            valid_out_reg <= 1'b1;
            count <= 2'd0;
        end else begin
            data_sum <= data_sum + data_in;
            count <= count + 1'b1;
            valid_out_reg <= 1'b0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

always @(posedge clk) begin
    if (valid_out_reg) begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_sum;

endmodule
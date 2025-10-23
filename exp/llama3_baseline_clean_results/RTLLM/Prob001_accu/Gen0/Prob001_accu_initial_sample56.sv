module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg     [1:0]      cnt;
reg     [9:0]      sum;
reg                 valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt         <= 2'b00;
        sum         <= 10'b0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        cnt         <= cnt + 1'b1;
        sum         <= sum + data_in;
        valid_out_reg <= 1'b0;
    end else begin
        cnt         <= cnt;
        sum         <= sum;
        valid_out_reg <= 1'b0;
    end
end

always @(posedge clk) begin
    if (cnt == 2'b11) begin
        valid_out_reg <= 1'b1;
        cnt         <= 2'b00;
        sum         <= 10'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out  = (cnt == 2'b11)? sum : 10'b0;

endmodule
module accu (
    input               clk,
    input               rst_n,
    input      [7:0]     data_in,
    input               valid_in,
    output              valid_out,
    output     [9:0]     data_out
);

reg   [9:0]     sum;
reg   [1:0]     cnt;
reg               valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum         <= 10'd0;
        cnt         <= 2'd0;
        valid_out_reg <= 1'd0;
    end else begin
        if (valid_in) begin
            if (cnt == 4'd3) begin
                sum         <= sum + data_in;
                valid_out_reg <= 1'd1;
                cnt         <= 2'd0;
            end else begin
                sum         <= (cnt == 2'd0) ? data_in : sum + data_in;
                cnt         <= cnt + 1'd1;
                valid_out_reg <= 1'd0;
            end
        end else begin
            valid_out_reg <= 1'd0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = (cnt == 4'd3) ? sum : 10'd0;

endmodule
module accu(
    input               clk,
    input               rst_n,
    input      [7:0]    data_in,
    input               valid_in,
    output              valid_out,
    output     [9:0]    data_out
);

reg [1:0]  cnt;
reg [9:0]  sum;
reg [9:0]  reg_data_out;
reg        reg_valid_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt          <= 2'd0;
        sum          <= 10'd0;
        reg_data_out <= 10'd0;
        reg_valid_out <= 1'd0;
    end else begin
        if (valid_in) begin
            sum          <= sum + data_in;
            cnt          <= cnt + 1'd1;
        end

        if (cnt == 4'd4) begin
            reg_data_out <= sum;
            reg_valid_out <= 1'd1;
            cnt          <= 2'd0;
            sum          <= 10'd0;
        end else begin
            reg_valid_out <= 1'd0;
        end
    end
end

assign data_out  = reg_data_out;
assign valid_out = reg_valid_out;

endmodule
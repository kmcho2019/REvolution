module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [1:0]  cnt;
reg [9:0]  accu_sum;
reg        prev_valid_in;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt         <= 2'd0;
        accu_sum    <= 10'd0;
        prev_valid_in <= 1'b0;
        valid_out   <= 1'b0;
    end else begin
        prev_valid_in <= valid_in;
        if (valid_in) begin
            if (cnt == 4'd3) begin
                accu_sum    <= accu_sum + data_in;
                valid_out   <= 1'b1;
                cnt         <= 2'd0;
            end else begin
                accu_sum    <= (cnt == 2'd0)? data_in : accu_sum + data_in;
                cnt         <= cnt + 1'd1;
                valid_out   <= 1'b0;
            end
        end else if (prev_valid_in) begin
            valid_out   <= 1'b0;
        end
        data_out    <= accu_sum;
    end
end

endmodule
module accu (
    input         clk,
    input         rst_n,
    input  [7:0]  data_in,
    input         valid_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [1:0] cnt;
reg [9:0] accu_sum;
reg        valid_out_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt         <= 2'd0;
        accu_sum   <= 10'd0;
        valid_out_r <= 1'd0;
    end else begin
        valid_out_r <= 1'd0;
        if (valid_in) begin
            accu_sum <= accu_sum + data_in;
            cnt      <= cnt + 1;
            if (cnt == 2'd3) begin
                valid_out_r <= 1'd1;
                cnt         <= 2'd0;
                accu_sum   <= 10'd0;
            end
        end
    end
end

assign valid_out = valid_out_r;
assign data_out  = accu_sum;

endmodule
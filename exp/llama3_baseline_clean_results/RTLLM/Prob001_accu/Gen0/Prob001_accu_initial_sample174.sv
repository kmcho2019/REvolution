module accu (
    input             clk,
    input             rst_n,
    input       [7:0] data_in,
    input             valid_in,
    output            valid_out,
    output      [9:0] data_out
);

reg [1:0] cnt;
reg [9:0] sum;
reg       valid_out_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt     <= 2'b00;
        sum     <= 10'b0;
        valid_out_r <= 1'b0;
    end else begin
        if (valid_in) begin
            sum     <= sum + data_in;
            cnt     <= cnt + 1;
        end
        if (cnt == 4'b100) begin
            valid_out_r <= 1'b1;
        end else begin
            valid_out_r <= 1'b0;
        end
        if (cnt == 4'b100) begin
            cnt     <= 2'b00;
            sum     <= 10'b0;
        end
    end
end

assign valid_out = valid_out_r;
assign data_out  = (cnt == 4'b100) ? sum : 10'b0;

endmodule
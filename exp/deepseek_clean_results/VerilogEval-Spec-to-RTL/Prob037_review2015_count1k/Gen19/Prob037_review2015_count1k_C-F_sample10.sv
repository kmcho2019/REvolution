module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [2:0] lower_cnt;  // 0-7
reg [6:0] upper_cnt;  // 0-124
wire lower_max = (lower_cnt == 3'd7);

always @(posedge clk) begin
    if (reset) begin
        lower_cnt <= 3'd0;
        upper_cnt <= 7'd0;
    end else begin
        lower_cnt <= lower_cnt + 1'b1;
        
        if (lower_max) begin
            upper_cnt <= (upper_cnt == 7'd124) ? 7'd0 : upper_cnt + 1'b1;
        end
    end
end

always @(*) begin
    q = upper_cnt * 8 + lower_cnt;
end

endmodule
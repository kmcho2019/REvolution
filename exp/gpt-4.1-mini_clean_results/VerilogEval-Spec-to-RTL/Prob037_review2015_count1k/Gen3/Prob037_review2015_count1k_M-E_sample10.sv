module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

reg [3:0] low_cnt;  // 0 to 9
reg [6:0] high_cnt; // 0 to 99 (7 bits)

// Multiply high_cnt by 10 and add low_cnt
// Because 10*99 = 990 max, fits in 10 bits
wire [9:0] combined_count = (high_cnt * 10) + low_cnt;

always @(posedge clk) begin
    if (reset) begin
        low_cnt <= 4'd0;
        high_cnt <= 7'd0;
        q <= 10'd0;
    end else begin
        if (low_cnt == 4'd9) begin
            low_cnt <= 4'd0;
            if (high_cnt == 7'd99) begin
                high_cnt <= 7'd0;
            end else begin
                high_cnt <= high_cnt + 7'd1;
            end
        end else begin
            low_cnt <= low_cnt + 4'd1;
        end
        q <= combined_count;
    end
end

endmodule
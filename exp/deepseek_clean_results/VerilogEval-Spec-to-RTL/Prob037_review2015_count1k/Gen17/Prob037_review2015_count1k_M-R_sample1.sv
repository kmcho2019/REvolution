module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [2:0] lower_cnt;  // 0-7
reg [6:0] upper_cnt;  // 0-124

// Continuous assignment for output
assign q = {upper_cnt, lower_cnt};

// Terminal count when combined count reaches 999
wire terminal_count = (q == 10'd999);

always @(posedge clk) begin
    if (reset) begin
        lower_cnt <= 3'd0;
        upper_cnt <= 7'd0;
    end else begin
        if (terminal_count) begin
            lower_cnt <= 3'd0;
            upper_cnt <= 7'd0;
        end else begin
            if (lower_cnt == 3'd7) begin
                lower_cnt <= 3'd0;
                upper_cnt <= upper_cnt + 1'b1;
            end else begin
                lower_cnt <= lower_cnt + 1'b1;
            end
        end
    end
end

endmodule
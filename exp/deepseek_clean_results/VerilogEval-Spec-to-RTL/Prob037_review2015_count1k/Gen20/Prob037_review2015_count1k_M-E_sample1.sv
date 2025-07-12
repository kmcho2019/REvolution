module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [5:0] lower_cnt;  // 0-63 (6 bits)
reg [3:0] upper_cnt;  // 0-15 (4 bits)

wire lower_wrap = (lower_cnt == 6'd63);
wire upper_wrap = (upper_cnt == 4'd15);
wire lower_term = (lower_cnt == 6'd39);
wire terminal_count = upper_wrap & lower_term;

always @(posedge clk) begin
    if (reset || terminal_count) begin
        lower_cnt <= 6'd0;
        upper_cnt <= 4'd0;
    end else begin
        lower_cnt <= lower_cnt + 6'd1;
        if (lower_wrap) begin
            upper_cnt <= upper_cnt + 4'd1;
        end
    end
end

assign q = {upper_cnt, lower_cnt};

endmodule
module radix2_div(
    input         clk,
    input         rst,
    input         sign,
    input  [7:0]  dividend,
    input  [7:0]  divisor,
    input         opn_valid,
    output        res_valid,
    output [15:0] result
);

reg [7:0] neg_divisor;
reg [15:0] sr;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;

// Save inputs and initialize registers
always @(posedge clk) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
        neg_divisor <= (sign) ? divisor : ~divisor + 1;
        sr <= {abs_dividend, 1'b0};
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Perform division
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            cnt <= 0;
            result <= {sr[15:8], sr[7:0]};
            res_valid <= 1;
        end else begin
            if (sr[15:8] >= {8'b0, abs_divisor}) begin
                sr <= {sr[14:0], 1'b1};
                sr[15:8] <= sr[15:8] - {8'b0, abs_divisor};
            end else begin
                sr <= {sr[14:0], 1'b0};
            end
            cnt <= cnt + 1;
        end
    end
end

// Clear res_valid when result is consumed
always @(posedge clk) begin
    if (rst || res_valid) begin
        res_valid <= 0;
    end
end

endmodule
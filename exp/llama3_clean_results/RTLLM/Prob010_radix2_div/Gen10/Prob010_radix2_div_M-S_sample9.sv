module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] dividend_reg;  
reg [7:0] divisor_reg;  
reg [8:0] sr;  
reg [3:0] cnt;  
reg start_cnt;

// Initialize dividend and divisor
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 9'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            dividend_reg <= (sign && dividend[7])? ~dividend + 1 : dividend;
            divisor_reg <= (sign && divisor[7])? ~divisor + 1 : divisor;
            sr <= {1'b0, (sign && dividend[7])? ~dividend + 1 : dividend};
            cnt <= 4'd1;
            start_cnt <= 1'b1;
        end

        if (start_cnt) begin
            if (cnt == 4'd8) begin
                result <= {sr[8:1], sr[0] ? 8'd0 : {8{1'b1}} - divisor_reg};
                res_valid <= 1'b1;
                start_cnt <= 1'b0;
            end else if (sr[8]) begin
                sr <= {sr[7:0], 1'b1} - {1'b0, divisor_reg};
                cnt <= cnt + 1;
            end else begin
                sr <= {sr[7:0], 1'b0};
                cnt <= cnt + 1;
            end
        end

        if (rst || !opn_valid && res_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule
module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr; // Shift register
reg [7:0] neg_divisor;
reg start_cnt;
reg [3:0] cnt;
reg res_valid_reg;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 16'd0;
        neg_divisor <= 8'd0;
        start_cnt <= 1'b0;
        cnt <= 4'd0;
        res_valid_reg <= 1'b0;
    end else if (opn_valid && !res_valid_reg) begin
        // Save inputs
        dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
        divisor_reg <= sign ? {{7{divisor[7]}}, divisor[7:0]} : {8'd0, divisor[7:0]};
        // Initialize shift register with absolute value of dividend shifted left
        sr <= {dividend_reg[7:0], 1'b0};
        // Negate absolute value of divisor
        neg_divisor <= ~divisor_reg[7:0] + 1'b1;
        start_cnt <= 1'b1;
        cnt <= 4'd1;
    end else if (start_cnt) begin
        if (cnt == 4'd8) begin
            // Division complete, update result
            result <= {sr[15:8], sr[7:0]};
            res_valid_reg <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 4'd0;
        end else begin
            // Perform subtraction
            reg [8:0] sub_result;
            sub_result <= {1'b0, sr[7:0]} - neg_divisor;
            // Update shift register based on carry-out
            if (sub_result[8]) begin
                sr <= {1'b1, sr[7:0]} << 1;
            end else begin
                sr <= {1'b0, sr[7:0]} << 1 | sub_result[0];
            end
            cnt <= cnt + 4'd1;
        end
    end else if (res_valid_reg) begin
        // Reset res_valid when result is consumed
        res_valid_reg <= 1'b0;
    end
end

assign res_valid = res_valid_reg;

endmodule
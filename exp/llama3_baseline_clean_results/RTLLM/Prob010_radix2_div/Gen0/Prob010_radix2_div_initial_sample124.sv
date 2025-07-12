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
reg [7:0] sr; // Shift register for remainder and quotient
reg [7:0] neg_divisor; // Negated absolute value of divisor
reg [3:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start division
reg [15:0] result_reg; // Register for result
reg res_valid_reg; // Register for result validity

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 8'd0;
        neg_divisor <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        res_valid_reg <= 1'b0;
    end else begin
        if (opn_valid && !res_valid_reg) begin
            dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : dividend;
            divisor_reg <= sign ? {{7{divisor[7]}}, divisor[7:0]} : divisor;
            sr <= {1'b0, dividend_reg};
            neg_divisor <= ~divisor_reg + 1'b1;
            cnt <= 4'd1;
            start_cnt <= 1'b1;
        end

        if (start_cnt) begin
            if (cnt == 4'd8) begin
                cnt <= 4'd0;
                start_cnt <= 1'b0;
                result_reg <= {sr[15:8], sr[7:0]};
                res_valid_reg <= 1'b1;
            end else begin
                cnt <= cnt + 1'b1;
                if (sr[7:0] >= divisor_reg) begin
                    sr <= {sr[15:1], 1'b1};
                    sr[7:0] <= sr[7:0] - divisor_reg;
                end else begin
                    sr <= {sr[15:1], 1'b0};
                end
            end
        end

        if (res_valid_reg && ~opn_valid) begin
            res_valid_reg <= 1'b0;
        end
    end
end

assign result = result_reg;
assign res_valid = res_valid_reg;

endmodule
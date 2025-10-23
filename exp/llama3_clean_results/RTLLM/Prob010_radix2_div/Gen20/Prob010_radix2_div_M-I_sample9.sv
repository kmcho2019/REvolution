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
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;
reg [8:0] sub_result;
reg [7:0] neg_divisor;

always @(posedge clk) begin
    if (rst) begin
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
    end else if (opn_valid && !res_valid) begin
        // Correctly sign-extend the dividend and divisor
        if (sign) begin
            dividend_reg <= (dividend[7] == 1'b1) ? {8{1'b1}} : {8{1'b0}};
            dividend_reg <= {dividend_reg, dividend};
            divisor_reg <= (divisor[7] == 1'b1) ? {8{1'b1}} : {8{1'b0}};
            divisor_reg <= {divisor_reg, divisor};
        end else begin
            dividend_reg <= {8'd0, dividend};
            divisor_reg <= {8'd0, divisor};
        end
        neg_divisor <= ~divisor_reg + 1; // Compute the negated divisor
        shift_reg <= {1'b0, dividend_reg}; // Initialize shift register
        start_cnt <= 1;
        cnt <= 1;
        res_valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, form the result
            result <= {shift_reg[15:8], shift_reg[7:0]};
            res_valid <= 1;
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            sub_result = {1'b0, shift_reg[15:8]} + neg_divisor; // Perform subtraction with borrow
            if (sub_result[8]) begin
                shift_reg <= {sub_result[7:0], 1'b1, shift_reg[7:1]}; // Update shift register based on borrow
            end else begin
                shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
            end
            cnt <= cnt + 1;
        end
    end else if (!opn_valid && res_valid) begin
        res_valid <= 0;
    end
end

endmodule
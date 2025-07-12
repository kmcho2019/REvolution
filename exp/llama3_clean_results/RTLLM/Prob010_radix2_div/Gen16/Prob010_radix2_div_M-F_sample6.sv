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
reg div_by_zero;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        div_by_zero <= 0;
    end else if (opn_valid &&!res_valid) begin
        if (divisor == 0) begin
            div_by_zero <= 1;
            res_valid <= 1;
            result <= {8'b0, 8'b0}; // Handle division by zero
        end else begin
            div_by_zero <= 0;
            if (sign) begin
                dividend_reg <= {{7{dividend[7]}}, dividend[7:0]};
                divisor_reg <= {{7{divisor[7]}}, divisor[7:0]};
            end else begin
                dividend_reg <= {8'b0, dividend};
                divisor_reg <= {8'b0, divisor};
            end
            shift_reg <= {1'b0, dividend_reg}; // Initialize shift register
            cnt <= 1;
            start_cnt <= 1;
        end
    end else if (start_cnt) begin
        if (cnt == 8) begin
            result <= {shift_reg[15:8], shift_reg[7:0]}; // Update result
            start_cnt <= 0;
            res_valid <= 1; // Set res_valid upon completion
        end else if (shift_reg[15:8] >= divisor_reg) begin
            shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
            cnt <= cnt + 1;
        end else begin
            shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
            cnt <= cnt + 1;
        end
    end
end

// Include a separate logic to reset res_valid when the result is consumed
always @(posedge clk) begin
    if (rst || (!opn_valid && res_valid)) begin
        res_valid <= 0;
    end
end

endmodule
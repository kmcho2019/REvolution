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

// Operand Fetch Stage
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;

// Initialization Stage
reg [7:0] neg_divisor;
reg [15:0] shift_reg;

// Division Stage
reg [3:0] cnt;
reg start_cnt;

// Result Stage
reg [7:0] remainder;
reg [7:0] quotient;

always @(posedge clk) begin
    if (rst) begin
        // Reset all registers
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else begin
        // Operand Fetch Stage
        if (opn_valid && !res_valid) begin
            dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
            divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
        end

        // Initialization Stage
        if (opn_valid && !res_valid) begin
            neg_divisor <= ~divisor_reg + 1;
            shift_reg <= {8'b0, dividend_reg};
            start_cnt <= 1;
            cnt <= 0;
            res_valid <= 0;
        end

        // Division Stage
        if (start_cnt) begin
            if (cnt == 8) begin
                // Result Stage
                remainder <= shift_reg[15:8];
                quotient <= shift_reg[7:0];
                res_valid <= 1;
                start_cnt <= 0;
                cnt <= 0;
            end else begin
                if (shift_reg[15:8] >= divisor_reg) begin
                    shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
                end else begin
                    shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

always @(posedge clk) begin
    if (rst || (!opn_valid && res_valid)) begin
        res_valid <= 0;
    end
end

always @(*) begin
    result = {remainder, quotient};
end

endmodule
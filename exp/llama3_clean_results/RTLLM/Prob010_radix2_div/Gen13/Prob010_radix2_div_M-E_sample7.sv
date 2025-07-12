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

// Internal registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;

// Combinational logic for neg_divisor
assign neg_divisor = ~divisor_reg + 1;

// Carry-save adder
reg [7:0] p;
reg [7:0] g;
reg [7:0] sum;
reg [7:0] carry;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all internal signals
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        p <= 0;
        g <= 0;
        sum <= 0;
        carry <= 0;
    end else begin
        // Check for new operation and valid inputs
        if (opn_valid && !res_valid && divisor != 0) begin
            // Save inputs and initialize internal signals
            dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
            divisor_reg <= sign ? {{7{divisor[7]}}, divisor[7:0]} : divisor;
            shift_reg <= {8'b0, dividend_reg};
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end

        // Hybrid divider
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete, update result and reset signals
                result <= {shift_reg[15:8], shift_reg[7:0]};
                res_valid <= 1;
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                // Perform division step
                p <= shift_reg[15:8] - divisor_reg;
                g <= shift_reg[15:8] < divisor_reg;
                sum <= shift_reg[7:0] + (g ? 1'b1 : 1'b0);
                carry <= g;
                shift_reg <= {carry, sum, shift_reg[7:1]};
                cnt <= cnt + 1;
            end
        end

        // Reset result valid when operation is not valid
        if (!opn_valid && res_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule
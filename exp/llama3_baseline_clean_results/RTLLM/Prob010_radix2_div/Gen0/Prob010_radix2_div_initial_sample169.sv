module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start division
reg [7:0] abs_dividend; // Absolute value of dividend
reg [7:0] abs_divisor; // Absolute value of divisor
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder
reg carry_out; // Carry-out from subtraction

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
        sr <= 0;
        neg_divisor <= 0;
        quotient <= 0;
        remainder <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize shift register and counter
        if (!start_cnt) begin
            abs_dividend <= (sign ? (~dividend + 1) : dividend);
            abs_divisor <= (sign ? (~divisor + 1) : divisor);
            sr <= {1'b0, abs_dividend};
            neg_divisor <= ~abs_divisor + 1;
            start_cnt <= 1;
            cnt <= 1;
        end
        // Division process
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete, update result
                remainder <= sr[15:8];
                quotient <= sr[7:0];
                res_valid <= 1;
                start_cnt <= 0;
                cnt <= 0;
            end else begin
                // Compute subtraction and update shift register
                carry_out <= (sr[15:8] >= abs_divisor);
                if (carry_out) begin
                    sr <= {sr[14:0], 1'b1};
                end else begin
                    sr <= {sr[14:0], 1'b0};
                end
                sr <= sr - {abs_divisor, 8'b0};
                cnt <= cnt + 1;
            end
        end
    end else if (res_valid) begin
        // Result consumed, reset module
        res_valid <= 0;
    end
end

always @(*) begin
    if (sign) begin
        result = {remainder, quotient};
    end else begin
        result = {remainder, quotient};
    end
end

endmodule
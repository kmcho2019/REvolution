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

// internal signals
reg [7:0] sr; // shift register
reg [7:0] neg_divisor; // negated absolute value of divisor
reg [2:0] cnt; // counter for division process
reg start_cnt; // flag to start division process
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor
reg [7:0] quotient; // quotient
reg [7:0] remainder; // remainder
reg signed [8:0] sub_result; // subtraction result
reg carry_out; // carry-out from subtraction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset all signals
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
    end else if (opn_valid && !res_valid) begin
        // save inputs and initialize signals
        abs_dividend <= (sign) ? (~dividend + 1) : dividend;
        abs_divisor <= (sign) ? (~divisor + 1) : divisor;
        sr <= {1'b0, abs_dividend};
        neg_divisor <= (~abs_divisor + 1);
        cnt <= 1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        // division process
        if (cnt == 8) begin
            // division complete
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            if (sign) begin
                // signed division
                quotient <= (dividend[7] == divisor[7]) ? sr[7:0] : (~sr[7:0] + 1);
                remainder <= (dividend[7] == divisor[7]) ? sr[7:0] : (~sr[7:0] + 1);
            end else begin
                // unsigned division
                quotient <= sr[7:0];
                remainder <= sr[7:0];
            end
            result <= {remainder, quotient};
            res_valid <= 1'b1;
        end else begin
            // perform subtraction and update shift register
            sub_result <= {1'b0, sr[7:0]} - neg_divisor;
            carry_out <= (sub_result[8]) ? 1'b1 : 1'b0;
            sr <= {carry_out, sr[7:1]};
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        // result validity
        res_valid <= 1'b0;
    end
end

endmodule
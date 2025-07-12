module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [15:0] sr; // Shift register
reg [7:0] cnt; // Counter
reg start_cnt; // Start counter signal
reg [7:0] neg_divisor; // Negated absolute value of the divisor
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg signed [8:0] sub_result; // Subtraction result
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder
reg [15:0] temp_result; // Temporary result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        neg_divisor <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs and initialize shift register
            abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
            abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
            sr <= {1'b0, abs_dividend};
            neg_divisor <= (sign) ? divisor : {~divisor[7], divisor[7:0]} + 1;
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end else if (start_cnt) begin
            // Perform division
            sub_result <= sr[15:8] - neg_divisor;
            if (sub_result[8]) begin
                // If subtraction result is negative, update shift register accordingly
                sr <= {1'b1, sr[15:1]};
            end else begin
                // If subtraction result is non-negative, update shift register accordingly
                sr <= {1'b0, sr[15:1]} + sub_result[7:0];
            end
            cnt <= cnt + 1;
            if (cnt == 8) begin
                // Division is complete, update result
                remainder <= sr[15:8];
                quotient <= sr[7:0];
                temp_result <= {remainder, quotient};
                if (sign && (dividend[7] ^ divisor[7])) begin
                    temp_result <= {16'hFF} - temp_result + 1;
                end
                result <= temp_result;
                res_valid <= 1;
                start_cnt <= 0;
            end
        end else if (res_valid) begin
            // Result is valid, wait for it to be consumed
            res_valid <= !opn_valid;
        end
    end
end

endmodule
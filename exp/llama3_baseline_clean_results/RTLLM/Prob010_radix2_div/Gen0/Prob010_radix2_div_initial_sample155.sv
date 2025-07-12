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

reg [7:0] sr; // shift register
reg [7:0] neg_divisor; // negated absolute value of divisor
reg [3:0] cnt; // counter
reg start_cnt; // start counter signal
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor
reg [7:0] quotient; // quotient
reg [7:0] remainder; // remainder
reg valid_result; // valid result signal

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        quotient <= 0;
        remainder <= 0;
        valid_result <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // save inputs
            abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
            abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
            neg_divisor <= ~(abs_divisor) + 1;
            sr <= {1'b0, abs_dividend}; // initialize shift register
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                // division complete
                cnt <= 0;
                start_cnt <= 0;
                quotient <= sr[7:0];
                remainder <= sr[15:8];
                valid_result <= 1;
            end else begin
                // perform subtraction
                reg [8:0] sub_result;
                sub_result <= {1'b0, sr[15:8]} - abs_divisor;
                if (sub_result[8]) begin
                    // borrow
                    sr <= {1'b1, sr[15:1]};
                end else begin
                    // no borrow
                    sr <= {1'b0, sr[15:1]} + {8'b0, 1'b1};
                end
                cnt <= cnt + 1;
            end
        end

        if (valid_result && !res_valid) begin
            // update result
            result <= {remainder, quotient};
            res_valid <= 1;
        end

        if (rst || !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule
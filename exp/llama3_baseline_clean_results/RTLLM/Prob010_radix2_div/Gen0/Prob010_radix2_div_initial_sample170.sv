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

reg [7:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to indicate division start
reg [7:0] saved_dividend; // Saved dividend for operation
reg [7:0] saved_divisor; // Saved divisor for operation
reg signed [8:0] temp; // Temporary result for subtraction
reg signed [8:0] sub_result; // Result after subtraction
reg result_consumed; // Flag to indicate result consumption

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result_consumed <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize division
        saved_dividend <= dividend;
        saved_divisor <= divisor;
        sr <= {1'b0, dividend}; // Initialize shift register with dividend
        if (sign) begin
            // Handle signed division
            if (divisor[7]) begin
                neg_divisor <= ~(-divisor) + 1;
            end else begin
                neg_divisor <= ~(-divisor);
            end
        end else begin
            // Handle unsigned division
            neg_divisor <= ~(-divisor);
        end
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            start_cnt <= 0;
            cnt <= 0;
            // Update result with remainder and quotient
            result <= {sr[8:1], sr[0:7]};
            res_valid <= 1;
        end else begin
            // Perform subtraction
            temp <= {1'b0, sr[7:0]} - neg_divisor;
            sub_result <= temp;
            if (sub_result[8]) begin
                // Subtraction result is negative, shift in 0
                sr <= {sr[7:0], 1'b0};
            end else begin
                // Subtraction result is non-negative, shift in 1
                sr <= {sr[7:0], 1'b1};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid && !result_consumed) begin
        // Result is valid but not consumed
        if (opn_valid) begin
            result_consumed <= 1;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        result_consumed <= 0;
    end else if (res_valid && opn_valid) begin
        result_consumed <= 0;
    end
end

endmodule
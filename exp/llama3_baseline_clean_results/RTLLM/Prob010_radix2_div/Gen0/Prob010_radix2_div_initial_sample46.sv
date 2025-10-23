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

reg [7:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] quotient;
reg [7:0] remainder;
reg prev_opn_valid;

always @(posedge clk) begin
    if (rst) begin
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else begin
        if (!res_valid && opn_valid && !prev_opn_valid) begin
            // Save inputs and initialize internal state
            abs_dividend <= (sign ? ~dividend + 1 : dividend);
            abs_divisor <= (sign ? ~divisor + 1 : divisor);
            sr <= {1'b0, abs_dividend};
            neg_divisor <= ~abs_divisor + 1;
            cnt <= 1;
            start_cnt <= 1'b1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete, update result
                start_cnt <= 1'b0;
                quotient <= sr[7:0];
                remainder <= sr[15:8];
                result <= {remainder, quotient};
                res_valid <= 1'b1;
            end else begin
                // Perform division step
                reg [8:0] sub_result;
                sub_result <= sr[15:8] - neg_divisor;
                if (sub_result[8]) begin
                    // Subtraction result is negative, do not subtract
                    sr <= {1'b0, sr[14:0], 1'b0};
                end else begin
                    // Subtraction result is non-negative, subtract
                    sr <= {1'b0, sr[14:0], 1'b1};
                end
                cnt <= cnt + 1;
            end
        end

        // Manage result validity
        if (rst || (!opn_valid && prev_opn_valid)) begin
            res_valid <= 1'b0;
        end

        prev_opn_valid <= opn_valid;
    end
end

endmodule
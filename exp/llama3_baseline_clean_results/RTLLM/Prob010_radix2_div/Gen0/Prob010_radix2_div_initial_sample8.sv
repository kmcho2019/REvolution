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
reg [3:0] cnt; // Counter
reg start_cnt; // Flag to start the division process
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder
reg prev_opn_valid; // Previous value of opn_valid

// Initialize registers
initial begin
    sr = 8'b0;
    neg_divisor = 8'b0;
    cnt = 4'b0;
    start_cnt = 1'b0;
    quotient = 8'b0;
    remainder = 8'b0;
    prev_opn_valid = 1'b0;
    res_valid = 1'b0;
end

always @(posedge clk) begin
    if (rst) begin // Reset
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 4'b0;
        start_cnt <= 1'b0;
        quotient <= 8'b0;
        remainder <= 8'b0;
        prev_opn_valid <= 1'b0;
        res_valid <= 1'b0;
    end else begin
        if (~opn_valid && prev_opn_valid) begin // Operation completed
            res_valid <= 1'b1;
        end else if (opn_valid && ~res_valid) begin // New operation request
            // Save inputs
            if (sign) begin // Signed division
                remainder <= {1'b0, dividend[7:0]};
                neg_divisor <= ~({1'b0, divisor[7:0]}) + 1'b1;
            end else begin // Unsigned division
                remainder <= {1'b0, dividend[7:0]};
                neg_divisor <= ~({8'b0, divisor[7:0]}) + 1'b1;
            end
            cnt <= 4'b1;
            start_cnt <= 1'b1;
            res_valid <= 1'b0;
        end

        if (start_cnt) begin // Division process
            if (cnt == 4'b1000) begin // Division complete
                quotient <= remainder[7:0];
                remainder <= remainder[15:8];
                cnt <= 4'b0;
                start_cnt <= 1'b0;
            end else begin // Update shift register
                reg [8:0] sub_result;
                sub_result = {1'b0, remainder[15:8]} - neg_divisor;
                if (sub_result[8]) begin // Borrow
                    remainder <= {1'b1, remainder[15:8]} << 1;
                end else begin // No borrow
                    remainder <= {1'b0, remainder[15:8]} << 1;
                end
                remainder[0] <= sub_result[7];
                cnt <= cnt + 1'b1;
            end
        end

        prev_opn_valid <= opn_valid;
    end
end

assign result = {remainder[7:0], quotient[7:0]};

endmodule
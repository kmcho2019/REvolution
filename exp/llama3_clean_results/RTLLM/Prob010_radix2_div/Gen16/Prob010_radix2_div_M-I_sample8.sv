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

reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        remainder <= 0;
        quotient <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            remainder <= {1'b0, dividend}; // Initialize remainder with dividend shifted left by one bit
            neg_divisor <= divisor;
            if (sign) begin
                if (dividend[7]) begin
                    remainder <= {1'b0, ~dividend + 1}; // Take two's complement for negative dividend
                end
                if (divisor[7]) begin
                    neg_divisor <= ~divisor + 1; // Take two's complement for negative divisor
                end
            end
            start_cnt <= 1'b1;
            cnt <= 3'd1;
        end

        if (start_cnt) begin
            if (cnt == 3'd8) begin
                res_valid <= 1;
                if (sign && ((dividend[7] ^ divisor[7]) == 1'b1)) begin
                    // If signs were different, quotient should be negated
                    result <= {remainder[7:0], ~quotient + 1};
                end else begin
                    result <= {remainder[7:0], quotient};
                end
                start_cnt <= 0;
            end else begin
                if (remainder[7:0] >= neg_divisor) begin
                    remainder <= {remainder[6:0], 1'b1}; // Set the current quotient bit to 1
                    quotient <= quotient + (1 << (8 - cnt)); // Update quotient
                end else begin
                    remainder <= {remainder[6:0], 1'b0}; // Set the current quotient bit to 0
                end
                remainder <= remainder - neg_divisor; // Subtract divisor from remainder
                cnt <= cnt + 1'd1;
            end
        end

        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule
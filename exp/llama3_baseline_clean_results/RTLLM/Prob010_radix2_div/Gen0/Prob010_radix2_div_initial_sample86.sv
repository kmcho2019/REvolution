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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [8:0] sr;
reg [2:0] cnt;
reg start_cnt;

// Abs value calculation
always_comb begin
    if (sign) begin
        abs_dividend = (dividend[7] ? -dividend : dividend);
        abs_divisor = (divisor[7] ? -divisor : divisor);
    end else begin
        abs_dividend = dividend;
        abs_divisor = divisor;
    end
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the module
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        sr <= 0;
        neg_divisor <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize the division process
        abs_dividend <= dividend;
        abs_divisor <= divisor;
        sr <= {1'b0, abs_dividend};
        neg_divisor <= ~abs_divisor + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Perform the division process
        if (cnt == 8) begin
            // Division is complete
            cnt <= 0;
            start_cnt <= 0;
            if (sign) begin
                // Check for negative results
                if ((dividend[7] ^ divisor[7])) begin
                    result <= {sr[8:1], -sr[0]};
                end else begin
                    result <= {sr[8:1], sr[0]};
                end
            end else begin
                result <= {sr[8:1], sr[0]};
            end
        end else begin
            // Compute subtraction and update SR
            reg [8:0] sub_result;
            sub_result = sr - {1'b0, neg_divisor};
            if (sub_result[8]) begin
                // No borrow, update SR accordingly
                sr <= {1'b0, sr[7:0]} + 1;
            end else begin
                // Borrow, update SR accordingly
                sr <= {sub_result[7:0], 0};
            end
            cnt <= cnt + 1;
        end
    end
end

always_ff @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (cnt == 0 && start_cnt == 0 && opn_valid) begin
        res_valid <= 1;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

endmodule
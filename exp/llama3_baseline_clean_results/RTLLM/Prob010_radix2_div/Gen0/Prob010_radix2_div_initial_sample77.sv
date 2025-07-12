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
reg [15:0] sr; // shift register
reg [2:0] cnt;
reg start_cnt;
reg [15:0] temp_result;
reg signed [7:0] signed_dividend;
reg signed [7:0] signed_divisor;

always @(posedge clk) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Store inputs and start division
            if (sign) begin
                signed_dividend <= signed'(dividend);
                signed_divisor <= signed'(divisor);
                abs_dividend <= (signed_dividend < 0) ? -signed_dividend : signed_dividend;
                abs_divisor <= (signed_divisor < 0) ? -signed_divisor : signed_divisor;
            end else begin
                abs_dividend <= dividend;
                abs_divisor <= divisor;
            end
            neg_divisor <= ~abs_divisor + 1; // 2's complement
            sr <= {1'b0, abs_dividend}; // initialize shift register
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete, update result
                if (sign && (signed_dividend[7] != signed_divisor[7])) begin
                    temp_result <= {~sr[15:8] + 1, sr[7:0]}; // adjust for signed division
                end else begin
                    temp_result <= sr;
                end
                res_valid <= 1;
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                // Perform subtraction and update shift register
                reg [8:0] sub_result;
                sub_result <= {1'b0, sr[15:8]} - abs_divisor;
                if (sub_result[8]) begin
                    // borrow, add divisor back
                    sr <= {sub_result[7:0] + abs_divisor, 0};
                end else begin
                    sr <= {sub_result[7:0], 1};
                end
                cnt <= cnt + 1;
            end
        end

        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

assign result = temp_result;

endmodule
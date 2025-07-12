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

reg [7:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [15:0] temp_result;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize the shift register and start the division process
        abs_dividend <= (sign) ? (dividend[7] ? -dividend : dividend) : dividend;
        abs_divisor <= (sign) ? (divisor[7] ? -divisor : divisor) : divisor;
        sr <= {1'b0, abs_dividend};
        neg_divisor <= ~abs_divisor + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Perform the division process
        if (cnt == 8) begin
            // Division is complete
            temp_result <= {sr[15:8], sr[7:0]};
            res_valid <= 1;
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            // Update the shift register
            if (sr[15:8] >= neg_divisor) begin
                sr <= {1'b0, sr[14:0], 1'b1};
            end else begin
                sr <= {1'b0, sr[14:0], 1'b0};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        // Result is valid, wait for consumption
        if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

always @(posedge clk) begin
    if (res_valid) begin
        result <= temp_result;
    end
end

endmodule
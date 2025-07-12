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

reg [7:0] neg_divisor;
reg [8:0] sr; // 8 bits for the remainder and 1 bit for carry
reg [2:0] cnt; // 3 bits for counting up to 8
reg start_cnt;

always @ (posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
        start_cnt <= 1'b0;
        cnt <= 3'b0;
        sr <= 9'b0;
        neg_divisor <= 8'b0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize
        if (sign) begin
            // Signed division
            sr <= {1'b0, (dividend[7] ? -dividend : dividend)} << 1;
            neg_divisor <= (divisor[7] ? -divisor : divisor);
        end else begin
            // Unsigned division
            sr <= {1'b0, dividend} << 1;
            neg_divisor <= ~divisor + 1'b1;
        end
        start_cnt <= 1'b1;
        cnt <= 1'b1;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 8) begin
            // Division complete
            result <= {sr[8:1], sr[0]};
            res_valid <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 3'b0;
        end else begin
            // Subtraction
            if (sr[8]) begin
                // NEG_DIVISOR is greater, no subtraction, quotient bit is 0
                sr <= {sr[8], sr[7:0]} << 1;
            end else begin
                // Subtract NEG_DIVISOR, quotient bit is 1
                sr <= {1'b0, (sr[7:0] - neg_divisor)} << 1;
            end
            // Increment counter
            cnt <= cnt + 1'b1;
        end
    end
    // If result is consumed, clear res_valid
    if (res_valid && !opn_valid) begin
        res_valid <= 1'b0;
    end
end

endmodule
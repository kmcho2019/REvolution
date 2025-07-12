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

reg [15:0] sr;  // shift register
reg [3:0] cnt;  // counter
reg [7:0] neg_divisor;  // negated divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        neg_divisor <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            if (divisor == 0) begin
                // Handle division by zero
                res_valid <= 1;
                result <= {8'd0, 8'd0};  // undefined result
            end else if (sign) begin
                // Signed division
                sr <= {8'd0, (dividend[7] ? (~dividend + 8'd1) : dividend)};
                neg_divisor <= (divisor[7] ? (~divisor + 8'd1) : divisor);
            end else begin
                // Unsigned division
                sr <= {8'd0, dividend};
                neg_divisor <= divisor;
            end
            cnt <= 1;
            res_valid <= 0;
        end else if (cnt < 8) begin
            reg [8:0] temp;
            temp <= {1'b0, sr[15:8]} - neg_divisor;
            if (temp[8]) begin
                // Borrow
                sr <= {sr[15:8] + neg_divisor, sr[7:0], 1'b0};
            end else begin
                // No borrow
                sr <= {temp[7:0], sr[7:0], 1'b1};
            end
            cnt <= cnt + 1;
        end else if (!res_valid) begin
            result <= {sr[15:8], sr[7:0]};
            res_valid <= 1;
        end
    end
end

endmodule
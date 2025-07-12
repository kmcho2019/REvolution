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
reg div_in_progress;

// Division by zero detection
wire div_by_zero = (divisor == 0);

// Initialize dividend and divisor when opn_valid is high and not in progress
always @(posedge clk) begin
    if (rst) begin
        remainder <= 0;
        quotient <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        div_in_progress <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !div_in_progress) begin
            remainder <= sign ? (dividend[7] ? (~dividend + 1) : dividend) : dividend;
            neg_divisor <= sign ? (~divisor + 1) : divisor;
            div_in_progress <= 1'b1;
            cnt <= 3'd1;
        end
        
        // Division process
        if (div_in_progress) begin
            if (cnt < 8) begin
                if (remainder >= neg_divisor) begin
                    remainder <= remainder - neg_divisor;
                    quotient <= quotient + (1 << (8 - cnt));
                end
                remainder <= {remainder[6:0], 1'b0};
                cnt <= cnt + 1'd1;
            end else begin
                res_valid <= 1;
                result <= {remainder, quotient};
                div_in_progress <= 0;
            end
        end
        
        // Reset result valid when operation is not valid
        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule
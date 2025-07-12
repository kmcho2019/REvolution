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
reg start_div;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        remainder <= 0;
        quotient <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_div <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            remainder <= sign ? (dividend[7] ? (~dividend + 1) : dividend) : dividend;
            neg_divisor <= sign ? (~divisor + 1) : divisor;
            start_div <= 1'b1;
            cnt <= 3'd1;
        end

        if (start_div) begin
            if (cnt == 3'd8) begin
                res_valid <= 1;
                result <= {remainder, quotient};
                start_div <= 0;
            end else begin
                if (remainder[7:0] >= neg_divisor) begin
                    remainder <= {remainder[6:0], 1'b1};
                    quotient <= quotient + (1 << (8 - cnt));
                end else begin
                    remainder <= {remainder[6:0], 1'b0};
                end
                remainder <= remainder - neg_divisor;
                cnt <= cnt + 1'd1;
            end
        end

        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule
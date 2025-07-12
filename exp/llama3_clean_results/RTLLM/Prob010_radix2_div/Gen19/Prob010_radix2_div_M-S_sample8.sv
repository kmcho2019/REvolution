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
    end else if (opn_valid && !res_valid) begin
        // Initialize division process
        remainder <= (sign ? (dividend[7] ? (~dividend + 1) : dividend) : dividend) << 1;
        neg_divisor <= (sign ? (~divisor + 1) : divisor);
        quotient <= 0;
        cnt <= 1;
        start_div <= 1;
    end else if (start_div) begin
        if (cnt < 8) begin
            // Perform division
            if (remainder[7] == 0 && remainder >= neg_divisor) begin
                remainder <= remainder - neg_divisor;
                quotient <= quotient + (1 << (8 - cnt));
            end else begin
                remainder <= remainder << 1;
            end
            cnt <= cnt + 1;
        end else begin
            // Finalize division result
            res_valid <= 1;
            result <= {remainder[7:0], quotient};
            start_div <= 0;
        end
    end else if (res_valid && !opn_valid) begin
        // Reset division result
        res_valid <= 0;
    end
end

endmodule
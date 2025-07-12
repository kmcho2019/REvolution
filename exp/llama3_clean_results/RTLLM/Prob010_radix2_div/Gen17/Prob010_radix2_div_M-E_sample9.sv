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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] remainder;
reg [7:0] quotient;
reg [2:0] state;
reg [3:0] cnt;

always @(posedge clk) begin
    if (rst) begin
        state <= 0;
        cnt <= 0;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        remainder <= 0;
        quotient <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialization
        if (state == 0) begin
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            remainder <= {1'b0, dividend[7:0]};
            quotient <= 0;
            cnt <= 1;
            state <= 1;
        end
        // Division Process
        else if (state == 1) begin
            if (cnt == 8) begin
                state <= 2;
            end else begin
                if (remainder >= divisor_reg) begin
                    remainder <= remainder - divisor_reg;
                    quotient <= {quotient[6:0], 1'b1};
                end else begin
                    quotient <= {quotient[6:0], 1'b0};
                end
                remainder <= {remainder[6:0], dividend_reg[7 - cnt]};
                cnt <= cnt + 1;
            end
        end
        // Result Generation
        else if (state == 2) begin
            result <= {remainder, quotient};
            res_valid <= 1;
            state <= 0;
        end
    end
end

// Reset res_valid when result is consumed
always @(posedge clk) begin
    if (rst || (!opn_valid && res_valid)) begin
        res_valid <= 0;
    end
end

endmodule
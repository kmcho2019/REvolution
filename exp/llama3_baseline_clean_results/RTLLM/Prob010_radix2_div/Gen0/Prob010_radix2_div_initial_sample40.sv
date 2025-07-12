module radix2_div(
    input         clk,
    input         rst,
    input         sign,
    input  [7:0]  dividend,
    input  [7:0]  divisor,
    input         opn_valid,
    output        res_valid,
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [8:0] sr; // shift register
reg [8:0] neg_divisor; // negated absolute value of divisor
reg [3:0] cnt; // counter
reg        start_cnt; // start counter flag
reg [7:0] quotient; // quotient
reg [7:0] remainder; // remainder
reg        carry_out; // carry-out from subtraction

// save inputs and initialize when opn_valid is high and res_valid is low
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 9'd0;
        neg_divisor <= 9'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
    end else if (opn_valid &&!res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        if (sign) begin // signed division
            if (dividend[7]) begin
                sr <= {1'b1, ~dividend} + 9'd1;
            end else begin
                sr <= {1'b0, dividend};
            end
            if (divisor[7]) begin
                neg_divisor <= {1'b1, ~divisor} + 9'd1;
            end else begin
                neg_divisor <= {1'b0, divisor};
            end
        end else begin // unsigned division
            sr <= {1'b0, dividend};
            neg_divisor <= {1'b0, divisor};
        end
        cnt <= 4'd1;
        start_cnt <= 1'b1;
    end
end

// perform division process when start_cnt is high
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 4'd8) begin // division complete
            start_cnt <= 1'b0;
            if (sign) begin // signed division
                if (dividend_reg[7]) begin // dividend is negative
                    quotient <= -sr[7:0];
                end else begin
                    quotient <= sr[7:0];
                end
                if (divisor_reg[7]) begin // divisor is negative
                    remainder <= -sr[8:1];
                end else begin
                    remainder <= sr[8:1];
                end
            end else begin // unsigned division
                quotient <= sr[7:0];
                remainder <= sr[8:1];
            end
        end else begin // update shift register and counter
            {carry_out, sr} <= sr - neg_divisor;
            if (carry_out) begin // subtraction result is negative
                sr <= {1'b1, sr[8:1]} + {1'b0, divisor_reg};
            end else begin // subtraction result is non-negative
                sr <= {1'b0, sr[8:1]};
            end
            cnt <= cnt + 4'd1;
        end
    end
end

// manage result validity
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
    end else if (!start_cnt && cnt == 4'd8) begin
        res_valid <= 1'b1;
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 1'b0;
    end
end

// output result
assign result = {remainder, quotient};

endmodule
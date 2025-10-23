module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] saved_dividend;
reg [7:0] saved_divisor;
reg [7:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] quotient;
reg signed [7:0] signed_dividend;
reg signed [7:0] signed_divisor;

assign result = {sr[7:0], quotient};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        saved_dividend <= 0;
        saved_divisor <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        quotient <= 0;
    end else if (opn_valid &&!res_valid) begin
        saved_dividend <= dividend;
        saved_divisor <= divisor;
        if (sign) begin
            signed_dividend <= signed'({1'b0, dividend[6:0]});
            signed_divisor <= signed'({1'b0, divisor[6:0]});
            if (dividend[7]) begin
                signed_dividend <= -signed_dividend;
            end
            if (divisor[7]) begin
                signed_divisor <= -signed_divisor;
            end
            sr <= {1'b0, (signed_dividend > 0)? signed_dividend : {8{1'b0}}};
        end else begin
            sr <= {1'b0, dividend};
        end
        neg_divisor <= (sign && divisor[7])? {8{1'b1}} - divisor : {8{1'b0}} - divisor;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            if (sign) begin
                if (signed_dividend < 0) begin
                    quotient <= -quotient;
                end
                if (signed_divisor < 0) begin
                    sr <= {8{1'b0}} - sr;
                end
            end
        end else begin
            reg [7:0] sub;
            reg carry;
            sub <= sr[7:0] - neg_divisor;
            carry <= (sub[7] == 1'b1)? 1'b1 : 1'b0;
            sr <= {carry, sr[7:1]};
            quotient <= {quotient[6:0], ~carry};
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else if (cnt == 0 && start_cnt == 0 && opn_valid == 0) begin
        res_valid <= 1;
    end else if (res_valid && opn_valid) begin
        res_valid <= 0;
    end
end

endmodule
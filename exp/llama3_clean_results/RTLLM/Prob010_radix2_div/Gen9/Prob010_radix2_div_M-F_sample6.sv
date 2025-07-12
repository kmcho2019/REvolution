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

reg [7:0] abs_dividend;  // absolute value of dividend
reg [7:0] abs_divisor;  // absolute value of divisor
reg [7:0] neg_divisor;  // negated absolute value of divisor
reg sign_result;  // sign of result
reg [7:0] sr;  // shift register
reg [7:0] quotient;  // quotient
reg [2:0] cnt;  // counter
reg start_cnt;  // start counter signal

// Preprocessing stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        abs_dividend <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        sign_result <= 0;
        sr <= 0;
        quotient <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        abs_dividend <= (sign && dividend[7])? ~dividend + 1 : dividend;
        abs_divisor <= (sign && divisor[7])? ~divisor + 1 : divisor;
        neg_divisor <= ~abs_divisor + 1;
        sign_result <= sign && (dividend[7] ^ divisor[7]);
        sr <= {1'b0, abs_dividend};
        quotient <= 0;
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end
end

// Division process
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        quotient <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 1;
        end else begin
            reg [8:0] sub;
            sub <= sr + neg_divisor;
            if (sub[8]) begin
                sr <= {1'b0, sr[7:0]} << 1;
                quotient <= quotient << 1;
            end else begin
                sr <= {1'b1, sr[7:0]} << 1;
                quotient <= (quotient << 1) | 1'b1;
            end
            cnt <= cnt + 1;
        end
    end
end

// Result generation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        result <= 0;
    end else if (res_valid) begin
        result <= {sr[7:0], quotient};
    end
end

endmodule
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

reg [7:0] sr;  // Shift register to store the current remainder and quotient
reg [2:0] cnt;  // Counter to track the number of iterations
reg start_cnt;  // Flag to indicate the start of the division process
reg [7:0] neg_divisor;  // Negated absolute value of the divisor
reg [7:0] abs_dividend;  // Absolute value of the dividend
reg [7:0] abs_divisor;  // Absolute value of the divisor
reg sign_quotient;  // Sign of the quotient

always @(*) begin
    if (sign) begin
        abs_dividend = (dividend[7] == 1'b0)? dividend : (~dividend + 1'b1);
        abs_divisor = (divisor[7] == 1'b0)? divisor : (~divisor + 1'b1);
    end else begin
        abs_dividend = dividend;
        abs_divisor = divisor;
    end
end

always @(*) begin
    if (rst) begin
        res_valid <= 1'b0;
    end else if (opn_valid &&!res_valid) begin
        res_valid <= 1'b1;
    end else if (cnt == 3'b100) begin
        res_valid <= 1'b1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        sr <= 8'b0;
        cnt <= 3'b000;
        start_cnt <= 1'b0;
        neg_divisor <= 8'b0;
        res_valid <= 1'b0;
    end else if (opn_valid &&!res_valid) begin
        sr <= {1'b0, abs_dividend};
        neg_divisor <= (~abs_divisor + 1'b1);
        cnt <= 3'b001;
        start_cnt <= 1'b1;
        sign_quotient <= (sign && (dividend[7]!= divisor[7]));
    end else if (start_cnt) begin
        if (cnt == 3'b100) begin
            start_cnt <= 1'b0;
            result <= {sr[7:0], sr[7:0]};
            if (sign_quotient) begin
                result <= {~result[15:8] + 1'b1, ~result[7:0] + 1'b1};
            end
        end else begin
            reg [8:0] sub_result;
            sub_result <= sr[7:0] - abs_divisor;
            if (sub_result[8]) begin
                sr <= {1'b0, sr[7:1]};
            end else begin
                sr <= {1'b1, sr[7:1]};
            end
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule
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

reg [7:0] sr; // shift register
reg [7:0] neg_divisor; // negated absolute value of divisor
reg [2:0] cnt; // counter for division steps
reg start_cnt; // flag to indicate start of division
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor
reg [7:0] quotient; // quotient
reg [7:0] remainder; // remainder
reg valid_result; // flag to indicate valid result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 8'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        valid_result <= 1'd0;
        res_valid <= 1'd0;
        result <= 16'd0;
    end else if (opn_valid && !res_valid) begin
        // initialize division
        abs_dividend <= sign ? {~dividend[7], dividend[6:0]} + 1'd1 : dividend;
        abs_divisor <= sign ? {~divisor[7], divisor[6:0]} + 1'd1 : divisor;
        sr <= {1'd0, abs_dividend};
        neg_divisor <= {~abs_divisor[7], abs_divisor[6:0]} + 1'd1;
        cnt <= 3'd1;
        start_cnt <= 1'd1;
        valid_result <= 1'd0;
    end else if (start_cnt) begin
        // perform division
        if (cnt == 3'd8) begin
            // division complete
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            remainder <= sr[7:0];
            quotient <= sr[15:8];
            valid_result <= 1'd1;
        end else begin
            // perform subtraction and shift
            if (sr[15:8] >= neg_divisor) begin
                sr <= {sr[14:0], 1'd1};
            end else begin
                sr <= {sr[14:0], 1'd0};
            end
            sr <= {sr[14:0], sr[15] ? (sr[7:0] - neg_divisor) : sr[7:0]};
            cnt <= cnt + 1'd1;
        end
    end else if (valid_result && !res_valid) begin
        // output result
        result <= {remainder, quotient};
        res_valid <= 1'd1;
        valid_result <= 1'd0;
    end
end

always @(posedge clk) begin
    if (rst || (!opn_valid && res_valid)) begin
        res_valid <= 1'd0;
    end
end

endmodule
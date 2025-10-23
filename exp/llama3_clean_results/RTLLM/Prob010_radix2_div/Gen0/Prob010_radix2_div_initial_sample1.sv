module radix2_div(
    input               clk,
    input               rst,
    input               sign,
    input      [7:0]     dividend,
    input      [7:0]     divisor,
    input               opn_valid,
    output              res_valid,
    output     [15:0]    result
);

reg [15:0] sr; // shift register
reg [7:0]  neg_divisor; // negated absolute value of divisor
reg [2:0]  cnt; // counter
reg        start_cnt; // flag to start division
reg        valid_dividend; // flag to indicate valid dividend
reg [7:0]  abs_dividend; // absolute value of dividend
reg [7:0]  abs_divisor; // absolute value of divisor
reg        sign_dividend; // sign of dividend
reg        sign_divisor; // sign of divisor

// initialize flags and registers
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        valid_dividend <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        sign_dividend <= 0;
        sign_divisor <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // save inputs and initialize registers
        abs_dividend <= sign ? {~dividend[7], dividend[6:0]} + 1 : dividend;
        abs_divisor <= sign ? {~divisor[7], divisor[6:0]} + 1 : divisor;
        sign_dividend <= sign && dividend[7];
        sign_divisor <= sign && divisor[7];
        sr <= {1'b0, abs_dividend}; // initialize shift register
        neg_divisor <= sign ? divisor : ~divisor + 1; // negated absolute value of divisor
        cnt <= 1;
        start_cnt <= 1;
        valid_dividend <= 1;
    end else if (start_cnt) begin
        // division process
        if (cnt == 8) begin
            // division complete
            cnt <= 0;
            start_cnt <= 0;
            if (sign_dividend ^ sign_divisor) begin
                // adjust quotient and remainder for signed division
                sr[7:0] <= ~sr[7:0] + 1;
            end
        end else begin
            // update shift register and counter
            reg [8:0] tmp;
            tmp <= sr[15:8] - neg_divisor;
            sr <= {tmp[8], tmp[7:0], 1'b0};
            cnt <= cnt + 1;
        end
    end
end

// manage res_valid signal
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else if (start_cnt && cnt == 8) begin
        res_valid <= 1;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

// output result
assign result = {sr[15:8], sr[7:0]};

endmodule
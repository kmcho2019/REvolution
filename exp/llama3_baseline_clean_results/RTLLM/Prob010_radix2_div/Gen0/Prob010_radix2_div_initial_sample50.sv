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

reg [7:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated absolute value of divisor
reg [3:0] cnt; // counter
reg start_cnt; // start counter flag
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor
reg [7:0] quotient; // quotient
reg [7:0] remainder; // remainder
reg sign_result; // sign of result

// initialize values
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 4'b0;
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        abs_dividend <= 8'b0;
        abs_divisor <= 8'b0;
        quotient <= 8'b0;
        remainder <= 8'b0;
        sign_result <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        // initialize shift register with absolute value of dividend shifted left by one bit
        abs_dividend <= sign ? {1'b0, dividend[7:0]} : {8{1'b0}} + dividend;
        abs_divisor <= sign ? {1'b0, divisor[7:0]} : {8{1'b0}} + divisor;
        SR <= {1'b0, abs_dividend[7:0]};
        // initialize negated absolute value of divisor
        NEG_DIVISOR <= ~abs_divisor + 1;
        start_cnt <= 1'b1;
        cnt <= 4'b1;
    end else if (start_cnt) begin
        // division process
        if (cnt == 4'd8) begin
            // division complete
            start_cnt <= 1'b0;
            cnt <= 4'b0;
            res_valid <= 1'b1;
            result <= {remainder, quotient};
        end else begin
            // perform subtraction
            reg [8:0] sub_result;
            sub_result <= {1'b0, SR[7:0]} - NEG_DIVISOR;
            // update shift register based on subtraction result
            if (sub_result[8]) begin
                // borrow, so insert 0 and shift left
                SR <= {1'b0, SR[7:1], 1'b0};
            end else begin
                // no borrow, so insert 1 and shift left
                SR <= {1'b1, SR[7:1], 1'b0};
                quotient <= quotient + 1;
            end
            remainder <= SR[7:0];
            cnt <= cnt + 1;
        end
    end
end

// manage res_valid signal
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
    end else if (start_cnt && cnt == 4'd8) begin
        res_valid <= 1'b1;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 1'b0;
    end
end

endmodule
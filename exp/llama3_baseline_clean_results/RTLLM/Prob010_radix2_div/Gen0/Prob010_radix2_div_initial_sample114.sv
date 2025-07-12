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

reg [15:0] sr; // shift register
reg [7:0] neg_divisor; // negated divisor
reg [2:0] cnt; // counter
reg start_cnt; // flag to start counting
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor
reg [7:0] quotient; // quotient
reg [7:0] remainder; // remainder
reg valid; // flag to indicate result is valid

// initialize variables
initial begin
    sr = 16'd0;
    neg_divisor = 8'd0;
    cnt = 3'd0;
    start_cnt = 1'd0;
    abs_dividend = 8'd0;
    abs_divisor = 8'd0;
    quotient = 8'd0;
    remainder = 8'd0;
    valid = 1'd0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset all variables
        sr = 16'd0;
        neg_divisor = 8'd0;
        cnt = 3'd0;
        start_cnt = 1'd0;
        abs_dividend = 8'd0;
        abs_divisor = 8'd0;
        quotient = 8'd0;
        remainder = 8'd0;
        valid = 1'd0;
        res_valid = 1'd0;
    end else begin
        if (opn_valid && !res_valid) begin
            // save inputs and initialize variables
            abs_dividend = (sign) ? {~dividend[7], dividend[6:0]} + 1 : dividend;
            abs_divisor = (sign) ? {~divisor[7], divisor[6:0]} + 1 : divisor;
            neg_divisor = ~abs_divisor + 1;
            sr = {1'd0, abs_dividend};
            cnt = 3'd1;
            start_cnt = 1'd1;
            valid = 1'd0;
        end else if (start_cnt) begin
            if (cnt == 3'd8) begin
                // division complete, update result and valid flag
                remainder = sr[15:8];
                quotient = sr[7:0];
                result = {remainder, quotient};
                valid = 1'd1;
                start_cnt = 1'd0;
                cnt = 3'd0;
                res_valid = 1'd1;
            end else begin
                // perform subtraction and update shift register
                reg [8:0] temp;
                temp = {1'd0, sr[15:8]} - abs_divisor;
                if (temp[8]) begin
                    // borrow, update shift register
                    sr = {1'd1, sr[15:8]} << 1;
                end else begin
                    // no borrow, update shift register
                    sr = {1'd0, sr[15:8]} << 1;
                    sr[0] = 1'd1;
                end
                cnt = cnt + 1;
            end
        end
    end
end

// manage res_valid signal
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid = 1'd0;
    end else begin
        if (valid && !res_valid) begin
            res_valid = 1'd1;
        end else if (!opn_valid && res_valid) begin
            res_valid = 1'd0;
        end
    end
end

endmodule
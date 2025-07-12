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

reg [7:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of the divisor
reg [2:0] cnt;  // Counter for division steps
reg start_cnt;  // Flag to start the division
reg [7:0] abs_dividend;  // Absolute value of the dividend
reg [7:0] abs_divisor;  // Absolute value of the divisor
reg signed [8:0] sub_result;  // Subtraction result
reg carry_out;  // Carry-out from subtraction
reg sign_flag;  // Flag for signed division

// Handle reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        sign_flag <= 0;
    end
    else if (opn_valid && !res_valid) begin
        abs_dividend <= sign ? {1'b0, dividend[7:0]} : {1'b0, dividend[7:0]};
        abs_divisor <= sign ? {1'b0, divisor[7:0]} : {1'b0, divisor[7:0]};
        if (sign) begin
            sign_flag <= (dividend[7] ^ divisor[7]);
        end
        else begin
            sign_flag <= 0;
        end
        neg_divisor <= ~abs_divisor + 1;
        sr <= {1'b0, abs_dividend[7:0]};
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Perform division
always @(posedge clk) begin
    if (start_cnt) begin
        sub_result <= sr - neg_divisor;
        carry_out <= sub_result[8];
        if (cnt == 8) begin
            if (sign_flag) begin
                result <= {~sr[7:0] + 1, -sr[7]};
            end
            else begin
                result <= {sr[7:0], 8'd0};
            end
            start_cnt <= 0;
            cnt <= 0;
            res_valid <= 1;
        end
        else begin
            if (carry_out) begin
                sr <= {1'b0, sr[7:0]} + 1;
            end
            else begin
                sr <= {1'b0, sr[7:0]};
            end
            cnt <= cnt + 1;
        end
    end
end

// Manage result validity
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end
    else if (opn_valid && !res_valid) begin
        // No action
    end
    else if (res_valid && ~opn_valid) begin
        res_valid <= 0;
    end
end

endmodule
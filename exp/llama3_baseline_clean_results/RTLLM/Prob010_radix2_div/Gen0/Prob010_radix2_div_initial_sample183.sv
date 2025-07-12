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

// Internal signals and registers
reg [8:0] SR; // 9-bit shift register
reg [2:0] cnt; // 3-bit counter
reg start_cnt; // Start flag
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder
reg result_ready; // Result validity flag

// Combinational logic
assign result = {remainder, quotient};

always @(*) begin
    if (~start_cnt) begin
        // Initialize SR with absolute value of dividend shifted left by one bit
        SR = {1'b0, (sign ? (~dividend + 1) : dividend)};
        // Set NEG_DIVISOR to negated absolute value of divisor
        NEG_DIVISOR = (~(|divisor) ? 8'b0 : (sign ? (~divisor + 1) : divisor));
        // Set counter and start flag
        cnt = 1;
        start_cnt = 1;
    end
    else if (cnt == 8) begin
        // Division is complete
        cnt = 0;
        start_cnt = 0;
        // Update result
        remainder = SR[8:1];
        quotient = SR[0];
    end
    else begin
        // Update SR based on subtraction result
        if (SR[8:1] >= NEG_DIVISOR) begin
            SR = {SR[8:1] - NEG_DIVISOR, 1'b1};
        end
        else begin
            SR = {SR[8:1], 1'b0};
        end
        // Increment counter
        cnt = cnt + 1;
    end
end

// Sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers
        SR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        NEG_DIVISOR <= 0;
        quotient <= 0;
        remainder <= 0;
        result_ready <= 0;
        res_valid <= 0;
    end
    else begin
        // Update res_valid based on reset and result_ready
        if (result_ready) begin
            res_valid <= 1;
        end
        else if (rst) begin
            res_valid <= 0;
        end
        // Update result_ready based on counter and start_cnt
        if (cnt == 8 && start_cnt) begin
            result_ready <= 1;
        end
        else if (opn_valid && ~res_valid) begin
            result_ready <= 0;
        end
        // Update SR and counter based on start_cnt and opn_valid
        if (opn_valid && ~res_valid) begin
            SR <= {1'b0, (sign ? (~dividend + 1) : dividend)};
            NEG_DIVISOR <= (~(|divisor) ? 8'b0 : (sign ? (~divisor + 1) : divisor));
            cnt <= 1;
            start_cnt <= 1;
        end
    end
end

endmodule
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

reg [15:0] SR; // Shift register to hold the dividend and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [3:0] cnt; // Counter to track the number of iterations
reg start_cnt; // Flag to indicate the start of the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg borrow; // Borrow bit from subtraction

assign res_valid = (cnt == 8) && start_cnt;

always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize the shift register and NEG_DIVISOR
        abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= ~abs_divisor + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Perform the division process
        if (cnt == 8) begin
            // Division is complete, update the result
            result <= {SR[15:8], SR[7:0]};
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            // Subtract NEG_DIVISOR from SR
            {borrow, SR} <= SR - NEG_DIVISOR;
            // Update SR based on the borrow bit
            SR <= {SR[14:0], borrow};
            cnt <= cnt + 1;
        end
    end
end

endmodule
module radix2_div(
    input  logic clk,         // Clock signal
    input  logic rst,         // Reset signal
    input  logic sign,        // Signed or unsigned operation
    input  logic [7:0] dividend,  // Dividend
    input  logic [7:0] divisor,   // Divisor
    input  logic opn_valid,    // Operation valid
    output logic res_valid,    // Result valid
    output logic [15:0] result  // Result (quotient and remainder)
);

logic [7:0] neg_divisor;  // Negated divisor
logic [15:0] sr;          // Shift register for dividend
logic [7:0] abs_dividend;  // Absolute value of dividend
logic [7:0] abs_divisor;   // Absolute value of divisor
logic start_cnt;          // Start counter
logic [3:0] cnt;           // Counter for division steps
logic [7:0] sub_result;    // Subtraction result
logic carry_out;          // Carry out of subtraction

always_ff @(posedge clk) begin
    if (rst) begin
        // Reset all registers
        sr <= 0;
        neg_divisor <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        start_cnt <= 0;
        cnt <= 0;
        res_valid <= 0;
        result <= 0;
    end else if (opn_valid &&!res_valid) begin
        // Start a new operation
        abs_dividend <= (sign)? {{8{dividend[7]}}, dividend} : {8'd0, dividend};
        abs_divisor <= (sign)? {{8{divisor[7]}}, divisor} : {8'd0, divisor};
        sr <= {1'b0, abs_dividend};  // Initialize shift register
        neg_divisor <= ~abs_divisor + 1'b1;  // Negate divisor
        start_cnt <= 1'b1;
        cnt <= 1;
        res_valid <= 1'b0;
    end else if (start_cnt) begin
        // Perform division
        sub_result <= sr[7:0] - abs_divisor;
        carry_out <= (sub_result[7] == 1'b1)? 1'b1 : 1'b0;
        if (cnt == 8) begin
            // Division complete
            result <= {sr[15:8], sr[7:0]};
            res_valid <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 4'd0;
        end else begin
            // Update shift register
            sr <= {carry_out, sub_result, sr[15:8]};
            cnt <= cnt + 1;
        end
    end else if (res_valid &&!opn_valid) begin
        // Reset result validity when result is consumed
        res_valid <= 1'b0;
    end
end

endmodule
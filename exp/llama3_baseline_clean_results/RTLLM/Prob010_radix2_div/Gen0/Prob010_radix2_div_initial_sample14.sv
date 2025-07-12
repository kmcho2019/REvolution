module radix2_div(
    input clk,            // Clock signal
    input rst,            // Reset signal
    input sign,           // Signed or unsigned division (1 for signed, 0 for unsigned)
    input [7:0] dividend, // Dividend
    input [7:0] divisor,  // Divisor
    input opn_valid,      // Valid operation request
    output res_valid,     // Result validity
    output [15:0] result  // Result containing remainder and quotient
);

reg [7:0] neg_divisor;  // Negated absolute value of divisor
reg [8:0] sr;           // Shift register
reg [2:0] cnt;          // Counter
reg start_cnt;         // Flag to start counter
reg [7:0] dividend_reg; // Registered dividend
reg [7:0] divisor_reg;  // Registered divisor

// Initialize registers on reset or operation request
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize registers
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        neg_divisor <= ~divisor_reg + 1;  // 2's complement
        sr <= {1'b0, dividend_reg};  // Shift dividend left by one bit
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Perform division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result and clear flags
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 1;
            result <= {sr[8:1], sr[0]};
        end else begin
            // Update shift register and counter
            reg [8:0] temp;
            temp = sr - neg_divisor;
            if (temp[8]) begin
                // Carry-out, shift in 0
                sr <= {1'b0, sr[8:1]};
            end else begin
                // No carry-out, shift in 1
                sr <= {1'b1, sr[8:1]};
            end
            cnt <= cnt + 1;
        end
    end
end

// Manage result validity
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid && !opn_valid) begin
        // Result consumed, clear validity
        res_valid <= 0;
    end
end

endmodule
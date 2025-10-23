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

reg [7:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] result_reg;

// Determine the sign of the inputs
wire dividend_sign = dividend[7];
wire divisor_sign = divisor[7];

// Compute the absolute values of the inputs
wire [7:0] abs_dividend = (sign && dividend_sign) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign && divisor_sign) ? -divisor : divisor;

// Compute the negated absolute value of the divisor
assign neg_divisor = ~abs_divisor + 1;

// Initialize the result to zero
initial result_reg = 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (opn_valid && !res_valid) begin
        // Start the division process
        sr <= {1'b0, abs_dividend};
        start_cnt <= 1'b1;
        cnt <= 1'b1;
        res_valid <= 0;
    end else if (start_cnt) begin
        // Perform the division
        if (cnt == 8) begin
            // Division is complete
            result_reg <= {sr[15:8], sr[7:0]};
            res_valid <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 1'b0;
        end else begin
            // Update the shift register and counter
            reg [7:0] sub_result;
            wire carry_out;
            assign carry_out = (sr[7:0] < neg_divisor);
            assign sub_result = (sr[7:0] >= neg_divisor) ? sr[7:0] - neg_divisor : sr[7:0];
            sr <= {carry_out, sub_result, sr[15:8]};
            cnt <= cnt + 1'b1;
        end
    end else if (res_valid && !opn_valid) begin
        // Reset the result valid signal
        res_valid <= 1'b0;
    end
end

// Update the result based on the sign of the inputs
always @(posedge clk) begin
    if (sign) begin
        if (dividend_sign != divisor_sign) begin
            // Result is negative
            result <= -result_reg;
        end else begin
            // Result is positive
            result <= result_reg;
        end
    end else begin
        // Unsigned division
        result <= result_reg;
    end
end

endmodule
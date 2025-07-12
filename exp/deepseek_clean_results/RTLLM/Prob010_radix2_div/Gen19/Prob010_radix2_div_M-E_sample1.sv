module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Internal registers
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [15:0] shift_reg;  // {remainder, quotient}
reg [3:0] cycle_count;
reg q_sign;
reg r_sign;
reg processing;
reg early_term;
reg div_by_zero;

// Combinational signals
wire [7:0] divisor_neg = ~abs_divisor + 1;
wire [7:0] dividend_neg = ~dividend + 1;
wire [7:0] divisor_abs = divisor[7] & sign ? divisor_neg : divisor;
wire [7:0] dividend_abs = dividend[7] & sign ? dividend_neg : dividend;
wire [8:0] sub_result = {shift_reg[15:8], 1'b0} + {1'b0, divisor_neg};
wire [7:0] remainder = shift_reg[15:8];
wire remainder_zero = (remainder == 8'b0);

// Predictive carry-skip logic
wire [3:0] carry_propagate = {4{shift_reg[15]}};
wire [3:0] carry_generate = {4{divisor_neg[7]}};
wire carry_skip = |(carry_propagate & carry_generate);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
        shift_reg <= 16'b0;
        cycle_count <= 4'b0;
        processing <= 1'b0;
        early_term <= 1'b0;
        div_by_zero <= 1'b0;
    end else begin
        if (opn_valid && !processing && !res_valid) begin
            // Initialize operation
            abs_divisor <= divisor_abs;
            abs_dividend <= dividend_abs;
            q_sign <= sign & (dividend[7] ^ divisor[7]);
            r_sign <= sign & dividend[7];
            div_by_zero <= (divisor == 8'b0);
            
            if (divisor == 8'b0) begin
                // Handle division by zero
                result <= {dividend, 8'hFF};
                res_valid <= 1'b1;
            end else begin
                shift_reg <= {8'b0, dividend_abs};
                cycle_count <= 4'd1;
                processing <= 1'b1;
                early_term <= 1'b0;
            end
        end else if (processing) begin
            if (early_term || cycle_count == 4'd8) begin
                // Finalize operation
                if (shift_reg[15]) begin
                    // Correct negative remainder
                    shift_reg[15:8] <= shift_reg[15:8] + abs_divisor;
                end
                
                // Apply result signs
                result[15:8] <= r_sign ? ~shift_reg[15:8] + 1 : shift_reg[15:8];
                result[7:0] <= q_sign ? ~shift_reg[7:0] + 1 : shift_reg[7:0];
                res_valid <= 1'b1;
                processing <= 1'b0;
            end else begin
                // Perform division step
                if (carry_skip || sub_result[8]) begin
                    // Positive result - subtract and shift
                    shift_reg <= {sub_result[7:0], shift_reg[7:1], 1'b1};
                end else begin
                    // Negative result - just shift
                    shift_reg <= {shift_reg[15:8], shift_reg[7:1], 1'b0};
                end
                
                // Check for early termination
                early_term <= remainder_zero;
                cycle_count <= cycle_count + 1;
            end
        end else if (res_valid && !opn_valid) begin
            // Clear valid flag when operation complete
            res_valid <= 1'b0;
        end
    end
end

// Dynamic bit-width adjustment logic
wire [3:0] dividend_leading_zeros;
wire [3:0] divisor_leading_zeros;

leading_zero_counter lzc_dividend (
    .in(abs_dividend),
    .count(dividend_leading_zeros)
);

leading_zero_counter lzc_divisor (
    .in(abs_divisor),
    .count(divisor_leading_zeros)
);

endmodule

// Helper module for leading zero count
module leading_zero_counter (
    input [7:0] in,
    output reg [3:0] count
);
always @(*) begin
    casez(in)
        8'b1???????: count = 4'd0;
        8'b01??????: count = 4'd1;
        8'b001?????: count = 4'd2;
        8'b0001????: count = 4'd3;
        8'b00001???: count = 4'd4;
        8'b000001??: count = 4'd5;
        8'b0000001?: count = 4'd6;
        8'b00000001: count = 4'd7;
        default: count = 4'd8;
    endcase
end
endmodule
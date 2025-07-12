module radix2_div(
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
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;  // Negated divisor for subtraction
reg [15:0] shift_reg;  // Shift register for division
reg [3:0] cnt;         // Counter for division steps
reg start_cnt;        // Flag to start division

// Combinational logic for neg_divisor
assign neg_divisor = ~divisor_reg + 1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all internal signals
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else begin
        // Check for new operation and valid inputs
        if (opn_valid &&!res_valid && divisor!= 0) begin
            // Save inputs and initialize internal signals
            dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
            divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
            shift_reg <= {8'b0, dividend_reg};  // Initialize shift register
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end

        // Handle division by zero explicitly
        if (opn_valid &&!res_valid && divisor == 0) begin
            // Set result to indicate error or handle division by zero
            result <= 16'b0;  // Or a specific error code
            res_valid <= 1;
        end

        // Division process
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete, update result and reset signals
                result <= {shift_reg[15:8], shift_reg[7:0]};  // Upper 8 bits are remainder, lower 8 bits are quotient
                res_valid <= 1;
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                // Perform division step
                reg [7:0] sub_result;  // Result of subtraction
                reg carry;            // Carry-out from subtraction

                // Compute subtraction
                if (shift_reg[15:8] >= divisor_reg) begin
                    sub_result = shift_reg[15:8] - divisor_reg;
                    carry = 1'b1;
                end else begin
                    sub_result = shift_reg[15:8];
                    carry = 1'b0;
                end

                // Update shift register
                shift_reg <= {sub_result, carry, shift_reg[7:1]};
                cnt <= cnt + 1;
            end
        end

        // Reset result valid when operation is not valid or reset is asserted
        if (!opn_valid && res_valid || rst) begin
            res_valid <= 0;
        end
    end
end

endmodule
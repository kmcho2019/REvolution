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

reg [7:0] SR; // Shift Register to hold the dividend and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track the division steps
reg start_cnt; // Flag to indicate the start of the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg is_signed; // Flag to track if the operation is signed
reg [15:0] res; // Register to hold the final result

// Initial values for the shift register and counter
always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs and initialize the shift register and counter
        abs_dividend <= sign? ~dividend + 1 : dividend;
        abs_divisor <= sign? ~divisor + 1 : divisor;
        is_signed <= sign;
        SR <= {1'b0, abs_dividend}; // Initialize SR with the absolute value of the dividend shifted left by one bit
        NEG_DIVISOR <= ~abs_divisor + 1; // Initialize NEG_DIVISOR with the negated absolute value of the divisor
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Division process
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division is complete
            cnt <= 0;
            start_cnt <= 0;
            // Update the result
            res <= {SR[15:8], SR[7:0]};
            res_valid <= 1;
        end else begin
            // Perform subtraction and update the shift register
            reg [8:0] sub_result;
            sub_result <= SR[7:0] - abs_divisor;
            if (sub_result[8]) begin
                // If there's a borrow, update SR accordingly
                SR <= {1'b1, SR[7:0]} << 1;
            end else begin
                // Otherwise, update SR with the result of the subtraction
                SR <= {1'b0, sub_result[7:0]} << 1;
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid &&!opn_valid) begin
        // Reset the result validity when the result is consumed
        res_valid <= 0;
    end
end

// Output the result
assign result = res;

endmodule
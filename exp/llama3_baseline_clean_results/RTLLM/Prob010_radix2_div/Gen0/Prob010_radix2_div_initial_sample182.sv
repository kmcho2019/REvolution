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

reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Flag to start the division process
reg [15:0] final_result; // Final result containing quotient and remainder
reg res_valid_reg; // Internal signal for res_valid

// Reset logic
always @(posedge clk) begin
    if (rst) begin
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid_reg <= 1'b0;
    end else if (opn_valid && !res_valid_reg) begin
        // Initialize SR with the absolute value of the dividend shifted left by one bit
        if (sign) begin
            SR <= {dividend[7] ? 8'b1 : 8'b0, dividend};
        end else begin
            SR <= {1'b0, dividend};
        end
        // Set NEG_DIVISOR to the negated absolute value of the divisor
        NEG_DIVISOR <= ~divisor + 1'b1;
        // Set the counter and start_cnt
        cnt <= 1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        // Perform the division process
        if (cnt == 8) begin
            // Update the shift register with the final remainder and quotient
            final_result <= {SR[15:8], SR[7:0]};
            start_cnt <= 1'b0;
            cnt <= 3'b0;
            res_valid_reg <= 1'b1;
        end else begin
            // Compute the subtraction of NEG_DIVISOR
            reg [8:0] temp;
            temp <= SR[15:8] - NEG_DIVISOR;
            // Use a multiplexer to select the appropriate result based on the carry-out
            if (temp[8]) begin
                SR <= {1'b0, SR[15:8], 1'b1};
            end else begin
                SR <= {1'b0, SR[15:8], 1'b0};
            end
            // Update SR by shifting left and inserting the carry-out
            SR <= {SR[14:0], temp[8]};
            // Increment the counter
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg && !opn_valid) begin
        res_valid_reg <= 1'b0;
    end
end

assign res_valid = res_valid_reg;
assign result = final_result;

endmodule
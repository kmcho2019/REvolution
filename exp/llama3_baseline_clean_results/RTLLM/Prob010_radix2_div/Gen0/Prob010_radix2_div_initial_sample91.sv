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

reg [7:0] saved_dividend;
reg [7:0] saved_divisor;
reg [15:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated absolute value of the divisor
reg [3:0] cnt; // Counter
reg start_cnt; // Flag to start the division process
reg [15:0] temp_result; // Temporary result
reg valid_res; // Flag to indicate valid result

always @ (posedge clk) begin
    if (rst) begin
        saved_dividend <= 8'b0;
        saved_divisor <= 8'b0;
        sr <= 16'b0;
        neg_divisor <= 8'b0;
        cnt <= 4'b0;
        start_cnt <= 1'b0;
        valid_res <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs
        saved_dividend <= sign ? {{7{dividend[7]}}, dividend[7:0]} : dividend;
        saved_divisor <= sign ? {{7{divisor[7]}}, divisor[7:0]} : divisor;
        // Initialize shift register SR
        sr <= {1'b0, saved_dividend[7:0]};
        // Set NEG_DIVISOR to the negated absolute value of the divisor
        neg_divisor <= ~saved_divisor + 1'b1;
        // Set counter cnt to 1 and start_cnt to 1
        cnt <= 4'b1;
        start_cnt <= 1'b1;
        valid_res <= 1'b0;
    end else if (start_cnt) begin
        // Perform division process
        if (cnt == 8) begin
            // Division is complete
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            // Update shift register SR with the final remainder and quotient
            temp_result <= {sr[15:8], sr[7:0]};
            valid_res <= 1'b1;
        end else begin
            // Increment counter cnt
            cnt <= cnt + 1'b1;
            // Compute subtraction of NEG_DIVISOR
            reg [8:0] sub_result;
            sub_result <= {1'b0, sr[7:0]} - neg_divisor;
            // Use a multiplexer to select the appropriate result based on the carry-out
            reg carry_out;
            carry_out <= sub_result[8];
            // Update SR by shifting left and inserting the carry-out
            sr <= {carry_out, sr[7:0], 1'b0};
        end
    end else if (valid_res && !opn_valid) begin
        res_valid <= 1'b1;
    end else if (rst) begin
        res_valid <= 1'b0;
    end
end

assign result = temp_result;

endmodule
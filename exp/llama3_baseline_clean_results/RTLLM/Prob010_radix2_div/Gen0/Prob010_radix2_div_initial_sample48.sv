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

reg [7:0] sr; // Shift register to hold the remainder and quotient
reg [7:0] neg_divisor; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track the division process
reg start_cnt; // Flag to indicate the start of the division process
reg [15:0] temp_result; // Temporary result register
reg valid_result; // Flag to indicate the result is valid

always @(posedge clk) begin
    if (rst) begin
        // Reset the module
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        valid_result <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize the division process
        sr <= (sign) ? ({1'b0, {7{~dividend[7]}}} + 1) : dividend;
        sr <= sr << 1;
        neg_divisor <= (sign) ? ({1'b0, {7{~divisor[7]}}} + 1) : divisor;
        neg_divisor <= ~neg_divisor + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Perform the division process
        if (cnt == 8) begin
            // Division is complete
            cnt <= 0;
            start_cnt <= 0;
            temp_result <= {sr[7:0], sr[7:0] >> 8};
            valid_result <= 1;
        end else begin
            // Update the shift register and counter
            reg [8:0] sub_result;
            sub_result <= {1'b0, sr[7:0]} - neg_divisor;
            if (sub_result[8]) begin
                // If the divisor fits, update the remainder and quotient
                sr <= {1'b1, sr[7:1]};
            end else begin
                // If the divisor does not fit, update the remainder and quotient
                sr <= {1'b0, ({1'b0, sr[7:0]} + neg_divisor)[7:0]};
            end
            sr <= sr << 1;
            cnt <= cnt + 1;
        end
    end
end

assign res_valid = valid_result;
assign result = temp_result;

endmodule
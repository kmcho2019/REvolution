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

reg [7:0] sr; // Shift register for remainder and quotient
reg [7:0] neg_divisor; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start division
reg [15:0] temp_result; // Temporary result before finalizing
reg valid_result; // Flag to indicate result validity
wire [8:0] subtract_result; // Result of subtraction

assign subtract_result = {1'b0, sr} - {1'b0, neg_divisor};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        valid_result <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs and initialize
        if (sign) begin
            // Signed operation
            sr <= ({1'b0, dividend[7:0]} << 1);
            neg_divisor <= (~({1'b0, divisor[7:0]})) + 1;
        end else begin
            // Unsigned operation
            sr <= ({1'b0, dividend[7:0]} << 1);
            neg_divisor <= (~({1'b0, divisor[7:0]})) + 1;
        end
        cnt <= 1;
        start_cnt <= 1;
        valid_result <= 0;
        res_valid <= 0;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            start_cnt <= 0;
            cnt <= 0;
            // Update result
            temp_result <= {sr[8:1], sr[0]};
            valid_result <= 1;
            res_valid <= 1;
        end else begin
            // Update shift register based on subtraction result
            if (subtract_result[8]) begin
                // No borrow, insert 1
                sr <= {1'b1, sr[8:1]};
            end else begin
                // Borrow, insert 0 and update remainder
                sr <= {1'b0, (sr[8:0] - neg_divisor[7:0])};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid &&!opn_valid) begin
        // Result consumed, reset flags
        res_valid <= 0;
        valid_result <= 0;
    end
end

assign result = valid_result? temp_result : 0;

endmodule
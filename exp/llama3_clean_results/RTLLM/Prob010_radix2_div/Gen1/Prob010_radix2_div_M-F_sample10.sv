module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,  // Corrected to reg type
    output [15:0] result
);

reg [15:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of the divisor
reg [2:0] cnt;  // Counter
reg start_cnt;  // Flag to start the counter
reg [7:0] quotient;  // Quotient
reg [7:0] remainder;  // Remainder

// Initialize the shift register, negated divisor, counter, and start flag
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;  // Reset res_valid on rst
    end else if (opn_valid && !res_valid) begin
        // Save the inputs dividend and divisor
        if (sign) begin
            // Signed division
            sr <= ({dividend[7] ? 8'hff : 8'h00} + dividend) << 1;
            neg_divisor <= ({divisor[7] ? 8'hff : 8'h00} + divisor);
        end else begin
            // Unsigned division
            sr <= dividend << 1;
            neg_divisor <= divisor;
        end
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Perform the division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete
            start_cnt <= 0;
            res_valid <= 1;  // Set res_valid when division is complete
            quotient <= sr[7:0];
            remainder <= sr[15:8];
        end else begin
            // Update the shift register and counter
            reg [8:0] subtraction;
            subtraction = {1'b0, sr[15:8]} - neg_divisor;
            if (subtraction[8]) begin
                // No borrow
                sr <= {1'b0, sr[15:8]} << 1;
            end else begin
                // Borrow
                sr <= {1'b1, sr[15:8]} + (neg_divisor << 1);
            end
            cnt <= cnt + 1;
        end
    end
end

// Assign the result
assign result = {remainder, quotient};

endmodule
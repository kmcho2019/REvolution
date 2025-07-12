module radix2_div (
    input clk, rst, sign, opn_valid,
    input [7:0] dividend, divisor,
    output res_valid,
    output [15:0] result
);

reg [7:0] SR; // Shift register for division
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Control signal for division start
reg [7:0] abs_dividend; // Absolute value of dividend
reg [7:0] abs_divisor; // Absolute value of divisor
reg [15:0] temp_result; // Temporary result for calculation
reg signed [7:0] signed_dividend; // Signed dividend
reg signed [7:0] signed_divisor; // Signed divisor

// Initialize values
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        temp_result <= 16'b0;
    end else if (opn_valid && !res_valid) begin
        abs_dividend <= (sign) ? {1'b0, dividend[7:0]} : {1'b0, dividend[7:0]};
        abs_divisor <= (sign) ? {1'b0, divisor[7:0]} : {1'b0, divisor[7:0]};
        signed_dividend <= (sign) ? -dividend : dividend;
        signed_divisor <= (sign) ? -divisor : divisor;
        if (~start_cnt) begin
            SR <= {1'b0, abs_dividend}; // Initialize shift register
            NEG_DIVISOR <= ~abs_divisor + 1; // Calculate negated divisor
            cnt <= 1; // Initialize counter
            start_cnt <= 1'b1; // Set start signal
        end
    end
end

// Division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 1'b0;
            cnt <= 3'b0;
            res_valid <= 1'b1;
            temp_result <= {SR[15:8], SR[7:0]}; // Store remainder and quotient
        end else begin
            // Compute subtraction
            reg [8:0] subtract_result;
            subtract_result <= {1'b0, SR[15:8]} - abs_divisor;
            // Update shift register based on carry-out
            if (subtract_result[8]) begin
                SR <= {1'b1, SR[15:8]} + abs_divisor;
            end else begin
                SR <= {1'b0, SR[15:8]} - abs_divisor;
            end
            SR <= {SR[14:0], subtract_result[8]}; // Shift left and insert carry-out
            cnt <= cnt + 1; // Increment counter
        end
    end
end

// Manage result validity
always @(posedge clk) begin
    if (rst || !opn_valid) begin
        res_valid <= 1'b0;
    end else if (start_cnt && cnt == 8) begin
        res_valid <= 1'b1;
    end
end

// Output result
assign result = (sign) ? {8'b0, (signed_dividend / signed_divisor), (signed_dividend % signed_divisor)} : temp_result;

endmodule
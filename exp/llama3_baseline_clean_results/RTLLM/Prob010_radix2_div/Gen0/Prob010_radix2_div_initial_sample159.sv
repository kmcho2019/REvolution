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

reg [15:0] sr; // Shift register to hold the dividend and quotient
reg [7:0] neg_divisor; // Negated absolute value of the divisor
reg [3:0] cnt; // Counter to track the number of iterations
reg start_cnt; // Flag to indicate the start of the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg [15:0] temp_result; // Temporary result

// Initialize the shift register and counter when opn_valid is high and res_valid is low
always @(posedge clk) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        abs_dividend <= (sign? { {7{dividend[7]}}, dividend[7:0] } : dividend);
        abs_divisor <= (sign? { {7{divisor[7]}}, divisor[7:0] } : divisor);
        sr <= {1'b0, abs_dividend};
        neg_divisor <= (~abs_divisor) + 1;
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Perform the division process when start_cnt is high
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            // Division is complete, update the result
            temp_result <= {sr[15:8], sr[7:0]};
            start_cnt <= 0;
            cnt <= 0;
            res_valid <= 1;
        end else begin
            // Update the shift register and counter
            reg [8:0] sub_result;
            sub_result <= sr[7:0] - neg_divisor;
            sr <= {sub_result[8], sr[7:0]} << 1;
            cnt <= cnt + 1;
        end
    end
end

// Update the result when res_valid is high
always @(posedge clk) begin
    if (res_valid) begin
        result <= (sign? { {8{temp_result[7]}}, temp_result[7:0] } : temp_result);
    end
end

// Manage result validity
always @(posedge clk) begin
    if (rst || (cnt!= 0)) begin
        res_valid <= 0;
    end
end

endmodule
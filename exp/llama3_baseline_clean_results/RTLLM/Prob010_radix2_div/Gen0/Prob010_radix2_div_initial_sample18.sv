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

reg [15:0] SR; // Shift Register to hold the intermediate result
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track the number of iterations
reg start_cnt; // Flag to indicate if the division process has started
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor

// Combinational logic to calculate the absolute values and negate the divisor
always @(*) begin
    abs_dividend = (sign && dividend[7]) ? (~dividend + 1) : dividend;
    abs_divisor = (sign && divisor[7]) ? (~divisor + 1) : divisor;
    NEG_DIVISOR = ~abs_divisor + 1;
end

// Sequential logic for the division process
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Start of division
        SR <= {1'b0, abs_dividend}; // Initialize SR with the absolute value of dividend shifted left by one bit
        start_cnt <= 1'b1;
        cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // End of division
            res_valid <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 1'b0;
        end else begin
            // Perform subtraction and update SR
            reg [16:0] tmp;
            tmp = {1'b0, SR} - {NEG_DIVISOR, 8'b0};
            if (tmp[16]) begin
                // If negative, insert 0
                SR <= {1'b0, SR[15:1]};
            end else begin
                // If non-negative, insert 1
                SR <= {1'b1, SR[15:1]};
            end
            cnt <= cnt + 1'b1;
        end
    end else if (res_valid) begin
        // Clear result validity when result is consumed or reset
        res_valid <= (rst) ? 1'b0 : res_valid;
    end
end

// Continuous assignment for the output
assign result = (sign && (dividend[7] != divisor[7])) ? ({8'b0, SR[7:0]} - {SR[15:8], 8'b0}) : {SR[15:8], SR[7:0]};

endmodule
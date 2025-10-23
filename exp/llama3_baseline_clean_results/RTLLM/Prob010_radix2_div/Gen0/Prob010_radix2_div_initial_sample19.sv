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

// internal signals
reg [7:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated absolute value of the divisor
reg [3:0] cnt; // counter
reg start_cnt; // flag to start the division process
reg [7:0] temp_dividend; // temporary dividend
reg [7:0] temp_divisor; // temporary divisor
reg [15:0] temp_result; // temporary result
reg valid_result; // flag to indicate if the result is valid
reg [7:0] quotient; // quotient
reg [7:0] remainder; // remainder
reg carry_out; // carry-out from subtraction

// initialize signals
initial begin
    SR = 8'd0;
    NEG_DIVISOR = 8'd0;
    cnt = 4'd0;
    start_cnt = 1'b0;
    temp_dividend = 8'd0;
    temp_divisor = 8'd0;
    temp_result = 16'd0;
    valid_result = 1'b0;
    quotient = 8'd0;
    remainder = 8'd0;
    carry_out = 1'b0;
end

// synchronous logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 8'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        temp_dividend <= 8'd0;
        temp_divisor <= 8'd0;
        temp_result <= 16'd0;
        valid_result <= 1'b0;
        quotient <= 8'd0;
        remainder <= 8'd0;
        carry_out <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid &&!res_valid) begin
        // save inputs
        temp_dividend <= dividend;
        temp_divisor <= divisor;
        
        // initialize signals
        SR <= {1'b0, dividend}; // shift left by one bit
        NEG_DIVISOR <= ~divisor + 1; // negated absolute value of the divisor
        cnt <= 4'd1;
        start_cnt <= 1'b1;
        valid_result <= 1'b0;
        quotient <= 8'd0;
        remainder <= 8'd0;
        carry_out <= 1'b0;
        res_valid <= 1'b0;
    end else if (start_cnt) begin
        // division process
        if (cnt == 8'd8) begin
            // division complete
            start_cnt <= 1'b0;
            cnt <= 4'd0;
            valid_result <= 1'b1;
            remainder <= SR[7:0];
            quotient <= SR[15:8];
            res_valid <= 1'b1;
        end else begin
            // subtraction and shift
            {carry_out, temp_result} <= SR - {NEG_DIVISOR, 8'd0};
            SR <= {carry_out, SR[15:1]};
            cnt <= cnt + 1;
        end
    end else if (valid_result &&!opn_valid) begin
        // result consumed
        valid_result <= 1'b0;
        res_valid <= 1'b0;
    end
end

// output logic
assign result = {remainder, quotient};

endmodule
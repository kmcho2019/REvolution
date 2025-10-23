module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Control unit signals
reg start_cnt;
reg [2:0] cnt;

// Carry-save adder signals
reg [7:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of the divisor
reg [7:0] quotient;  // Quotient of the division
reg carry_out;  // Carry-out from the subtraction

// Pipelined architecture signals
reg [7:0] stage1_sr;
reg [7:0] stage1_quotient;
reg stage1_carry_out;

// Control unit FSM
always @(posedge clk) begin
    if (rst) begin
        start_cnt <= 0;
        cnt <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            start_cnt <= 1;
            cnt <= 1;
            sr <= {1'b0, dividend};  // Initialize the shift register
            neg_divisor <= ~divisor + 1;  // Calculate the negated absolute value of the divisor
            quotient <= 0;
        end else if (start_cnt) begin
            if (cnt < 8) begin
                // Perform the division process
                stage1_sr <= sr;
                stage1_quotient <= quotient;
                stage1_carry_out <= carry_out;
                if (sr[7:0] >= divisor) begin
                    sr <= sr[7:0] - divisor;
                    quotient <= quotient + (1 << (8 - cnt));
                    carry_out <= 1;
                end else begin
                    sr <= sr[7:0];
                    quotient <= quotient;
                    carry_out <= 0;
                end
                sr <= {carry_out, sr[7:1]};  // Update the shift register
                cnt <= cnt + 1;
            end else begin
                // Division is complete
                start_cnt <= 0;
                res_valid <= 1;
                result <= {sr[7:0], quotient};  // Update the result
            end
        end
    end
end

// Carry-save adder
always @(posedge clk) begin
    if (rst) begin
        stage1_sr <= 0;
        stage1_quotient <= 0;
        stage1_carry_out <= 0;
    end else begin
        if (start_cnt) begin
            stage1_sr <= sr;
            stage1_quotient <= quotient;
            stage1_carry_out <= carry_out;
        end
    end
end

endmodule
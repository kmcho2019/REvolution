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

reg [7:0] dividend_reg;  // Declare missing variable
reg [16:0] sr;  // 17-bit shift register
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;  // negated absolute value of divisor
reg [3:0] cnt;  // counter
reg start_cnt;  // flag to start division
reg [1:0] state;  // finite state machine

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        state <= 0;
        result <= 0;
    end else begin
        case (state)
            2'b00: begin  // idle state
                if (opn_valid && !res_valid) begin
                    // Save inputs
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;

                    // Initialize registers
                    if (sign) begin
                        // Signed division
                        sr <= {1'b0, (dividend_reg[7]? (~dividend_reg + 1) : dividend_reg)};  // shift left by one bit
                        neg_divisor <= ~(divisor_reg[7]? (~divisor_reg + 1) : divisor_reg) + 1;  // negated absolute value of divisor
                    end else begin
                        // Unsigned division
                        sr <= {1'b0, dividend_reg};  // shift left by one bit
                        neg_divisor <= ~divisor_reg + 1;  // negated absolute value of divisor
                    end
                    cnt <= 1;
                    start_cnt <= 1;
                    state <= 2'b01;
                end
            end
            2'b01: begin  // division state
                if (start_cnt) begin
                    if (cnt == 8) begin
                        // Division complete
                        start_cnt <= 0;
                        cnt <= 0;
                        result <= {sr[16:9], sr[8:1]};  // update result
                        res_valid <= 1;
                        state <= 2'b10;
                    end else begin
                        // Update shift register
                        reg [8:0] temp;  // Temporary variable for calculation
                        if (sr[16] == 0) begin
                            temp = {1'b0, sr[15:8]} - neg_divisor;
                        end else begin
                            temp = {1'b0, sr[15:8]} + neg_divisor;
                        end
                        if (temp[8]) begin
                            sr <= {1'b1, sr[15:8]} << 1;  // shift left and insert carry-out
                        end else begin
                            sr <= {1'b0, temp[7:0]} << 1;  // shift left and insert carry-out
                        end
                        cnt <= cnt + 1;
                    end
                end
            end
            2'b10: begin  // completion state
                if (!opn_valid || res_valid) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

endmodule
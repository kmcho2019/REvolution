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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of the divisor
reg [3:0] cnt;  // Counter
reg start_div;

// State machine states
enum logic [1:0] {
    IDLE,
    INIT,
    DIVIDE,
    RESULT
} state, next_state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_div <= 0;
        res_valid <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid &&!res_valid) begin
                    state <= INIT;
                end
            end
            INIT: begin
                // Save the inputs dividend and divisor
                dividend_reg <= sign? {{8{dividend[7]}}, dividend} : dividend;
                divisor_reg <= sign? {{8{divisor[7]}}, divisor} : divisor;
                sr <= {1'b0, dividend_reg};
                neg_divisor <= ~divisor_reg + 1;  // Calculate negated absolute value of the divisor
                cnt <= 1;
                start_div <= 1;
                state <= DIVIDE;
            end
            DIVIDE: begin
                // Perform the division process
                if (cnt == 8) begin
                    state <= RESULT;
                end else begin
                    reg [8:0] subtraction;
                    assign subtraction = {1'b0, sr[15:8]} - {1'b0, neg_divisor};
                    if (subtraction[8]) begin
                        sr <= {1'b0, sr[15:8]} << 1;
                    end else begin
                        sr <= {1'b1, sr[15:8]} + ({1'b0, neg_divisor} << 1);
                    end
                    cnt <= cnt + 1;
                end
            end
            RESULT: begin
                // Update the result and validity flag
                result <= {sr[15:8], sr[7:0]};
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule
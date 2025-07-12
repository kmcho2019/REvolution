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

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    DIVIDE,
    RESULT
} state, next_state;

reg [7:0] dividend_reg;  // registered dividend
reg [7:0] divisor_reg;  // registered divisor
reg [8:0] sr;  // shift register with 1 extra bit for carry
reg [3:0] cnt;  // counter
reg [7:0] quotient;  // quotient
reg [7:0] remainder;  // remainder

// Combinational logic block
assign sr[8:0] = (dividend_reg[7:0] >= divisor_reg[7:0])? {1'b0, dividend_reg[7:0] - divisor_reg[7:0]} << 1 : {1'b1, dividend_reg[7:0]} << 1;

// FSM
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        cnt <= 0;
        quotient <= 0;
        remainder <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    if (sign) begin
                        // Signed division
                        dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
                        divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
                    end else begin
                        // Unsigned division
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;
                    end
                    state <= DIVIDE;
                end
            end
            DIVIDE: begin
                if (cnt < 8) begin
                    sr <= sr << 1;
                    if (sr[8] == 0) begin
                        if (sr[7:0] >= divisor_reg[7:0]) begin
                            sr <= {1'b0, sr[7:0] - divisor_reg[7:0]} << 1;
                        end else begin
                            sr <= {1'b1, sr[7:0]} << 1;
                        end
                    end else begin
                        if ({sr[8], sr[7:0]} >= {1'b0, divisor_reg[7:0]}) begin
                            sr <= {1'b0, sr[7:0] - divisor_reg[7:0]} << 1;
                        end else begin
                            sr <= {1'b1, sr[7:0]} << 1;
                        end
                    end
                    cnt <= cnt + 1;
                end else begin
                    state <= RESULT;
                end
            end
            RESULT: begin
                remainder <= sr[7:0];
                quotient <= sr[8];
                res_valid <= 1;
                result <= {remainder, quotient};
                state <= IDLE;
            end
        endcase
    end
end

endmodule
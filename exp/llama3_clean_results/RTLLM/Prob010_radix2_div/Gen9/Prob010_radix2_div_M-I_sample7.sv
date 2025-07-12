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
    PROCESS,
    RESULT
} state, next_state;

reg [7:0] dividend_reg;  // registered dividend
reg [7:0] divisor_reg;  // registered divisor
reg [15:0] sr;  // shift register with 8 extra bits for remainder and quotient
reg [3:0] cnt;  // counter
reg [7:0] quotient;  // quotient
reg [7:0] remainder;  // remainder
reg [15:0] result_reg;  // result register

// Initialize the registers
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        cnt <= 0;
        quotient <= 0;
        remainder <= 0;
        result_reg <= 0;
        res_valid <= 0;
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
                    sr <= {8'd0, dividend_reg};
                    state <= PROCESS;
                    cnt <= 1;
                end
            end
            PROCESS: begin
                if (cnt < 8) begin
                    reg [7:0] temp;
                    temp <= sr[15:8] - divisor_reg;
                    if (temp[7]) begin
                        // Borrow
                        sr <= {sr[15:8] + divisor_reg, sr[7:0], 1'b0};
                    end else begin
                        // No borrow
                        sr <= {temp, sr[7:0], 1'b1};
                    end
                    cnt <= cnt + 1;
                end else begin
                    remainder <= sr[15:8];
                    quotient <= sr[7:0];
                    state <= RESULT;
                end
            end
            RESULT: begin
                result_reg <= {remainder, quotient};
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

// Update the output result
always @(posedge clk) begin
    result <= result_reg;
end

endmodule
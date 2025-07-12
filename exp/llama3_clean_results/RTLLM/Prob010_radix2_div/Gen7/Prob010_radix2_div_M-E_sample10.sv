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

reg [2:0] state;  // state machine
reg [7:0] dividend_reg;  // registered dividend
reg [7:0] divisor_reg;  // registered divisor
reg [7:0] quotient;  // quotient
reg [7:0] remainder;  // remainder
reg [3:0] cnt;  // counter

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;  // IDLE state
    end else begin
        case (state)
            0: begin  // IDLE state
                if (opn_valid) begin
                    state <= 1;  // INIT state
                end
            end
            1: begin  // INIT state
                dividend_reg <= (sign && dividend[7])? ~dividend + 1 : dividend;
                divisor_reg <= (sign && divisor[7])? ~divisor + 1 : divisor;
                cnt <= 0;
                state <= 2;  // DIVIDE state
            end
            2: begin  // DIVIDE state
                if (cnt < 8) begin
                    if (remainder >= divisor_reg) begin
                        remainder <= remainder - divisor_reg;
                        quotient <= quotient + (1 << cnt);
                    end
                    remainder <= remainder << 1;
                    cnt <= cnt + 1;
                end else begin
                    state <= 3;  // RESULT state
                end
            end
            3: begin  // RESULT state
                result <= {remainder, quotient};
                res_valid <= 1;
                state <= 0;  // IDLE state
            end
        endcase
    end
end

// Reset res_valid when opn_valid is low
always @(posedge clk or posedge rst) begin
    if (rst || !opn_valid) begin
        res_valid <= 0;
    end
end

// Initialize remainder and quotient
always @(posedge clk or posedge rst) begin
    if (rst || state == 1) begin
        remainder <= {1'b0, dividend_reg};
        quotient <= 0;
    end
end

endmodule
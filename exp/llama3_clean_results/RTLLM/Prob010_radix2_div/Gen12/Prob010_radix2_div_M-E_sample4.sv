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
reg [7:0] remainder_reg;
reg [7:0] quotient_reg;
reg [2:0] state;
reg [3:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        remainder_reg <= 0;
        quotient_reg <= 0;
        counter <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (opn_valid) begin
                    state <= 1;
                    if (sign) begin
                        dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
                        divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
                    end else begin
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;
                    end
                    remainder_reg <= {1'b0, dividend_reg};
                    quotient_reg <= 0;
                end
            end
            1: begin // INIT
                state <= 2;
                counter <= 1;
            end
            2: begin // DIVIDE
                if (counter < 8) begin
                    reg [8:0] temp;
                    temp <= {1'b0, remainder_reg} - divisor_reg;
                    if (temp[8]) begin
                        remainder_reg <= {1'b0, remainder_reg};
                        quotient_reg <= quotient_reg << 1;
                    end else begin
                        remainder_reg <= temp[7:0];
                        quotient_reg <= (quotient_reg << 1) | 1'b1;
                    end
                    counter <= counter + 1;
                end else begin
                    state <= 3;
                end
            end
            3: begin // RESULT
                result <= {remainder_reg, quotient_reg};
                res_valid <= 1;
                state <= 0;
            end
        endcase
    end
end

endmodule
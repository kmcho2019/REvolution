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
reg [15:0] remainder_reg;
reg [7:0] quotient_reg;
reg [2:0] cnt;
reg [1:0] state; // 0: idle, 1: init, 2: divide

localparam IDLE = 2'b00;
localparam INIT = 2'b01;
localparam DIVIDE = 2'b10;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        cnt <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        remainder_reg <= 0;
        quotient_reg <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (opn_valid) begin
                    state <= INIT;
                    dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                    divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                end
            end
            INIT: begin
                remainder_reg <= {8'b0, dividend_reg};
                quotient_reg <= 8'b0;
                cnt <= 0;
                state <= DIVIDE;
                res_valid <= 0;
            end
            DIVIDE: begin
                if (cnt == 8) begin
                    state <= IDLE;
                    result <= {remainder_reg[15:8], quotient_reg};
                    res_valid <= 1;
                end else begin
                    if (remainder_reg[15:8] >= divisor_reg) begin
                        remainder_reg <= {remainder_reg[15:8] - divisor_reg, 1'b1, remainder_reg[7:1]};
                        quotient_reg <= {quotient_reg[6:0], 1'b1};
                    end else begin
                        remainder_reg <= {remainder_reg[15:8], 1'b0, remainder_reg[7:1]};
                        quotient_reg <= {quotient_reg[6:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule
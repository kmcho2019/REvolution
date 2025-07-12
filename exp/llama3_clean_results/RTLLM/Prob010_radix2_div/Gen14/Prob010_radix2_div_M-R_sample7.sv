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

// Combinational Logic
wire next_state;
wire [7:0] next_dividend_reg;
wire [7:0] next_divisor_reg;
wire [15:0] next_remainder_reg;
wire [7:0] next_quotient_reg;
wire [2:0] next_cnt;

assign next_state = (state == IDLE && opn_valid) ? INIT :
                    (state == INIT) ? DIVIDE :
                    (state == DIVIDE && cnt == 8) ? IDLE : state;

assign next_dividend_reg = (state == IDLE && opn_valid) ? (sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend}) : dividend_reg;
assign next_divisor_reg = (state == IDLE && opn_valid) ? (sign? {{7{divisor[7]}}, divisor[7:0]} : divisor) : divisor_reg;

assign next_remainder_reg = (state == INIT) ? {8'b0, dividend_reg} :
                             (state == DIVIDE && remainder_reg[15:8] >= divisor_reg) ? {remainder_reg[15:8] - divisor_reg, 1'b1, remainder_reg[7:1]} :
                             (state == DIVIDE) ? {remainder_reg[15:8], 1'b0, remainder_reg[7:1]} : remainder_reg;

assign next_quotient_reg = (state == INIT) ? 8'b0 :
                            (state == DIVIDE && remainder_reg[15:8] >= divisor_reg) ? {quotient_reg[6:0], 1'b1} :
                            (state == DIVIDE) ? {quotient_reg[6:0], 1'b0} : quotient_reg;

assign next_cnt = (state == INIT) ? 0 :
                  (state == DIVIDE) ? cnt + 1 : cnt;

// Sequential Logic
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
        state <= next_state;
        res_valid <= (next_state == IDLE && next_cnt == 8) ? 1 : 0;
        cnt <= next_cnt;
        dividend_reg <= next_dividend_reg;
        divisor_reg <= next_divisor_reg;
        remainder_reg <= next_remainder_reg;
        quotient_reg <= next_quotient_reg;
        result <= (next_state == IDLE && next_cnt == 8) ? {remainder_reg[15:8], quotient_reg} : result;
    end
end

endmodule
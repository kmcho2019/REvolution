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

// Enum for states
enum logic [1:0] {IDLE, START, DIVIDE, OUTPUT} state, next_state;

// Internal signals
reg [7:0] dividend_reg, divisor_reg;
reg sign_reg;
reg [15:0] shift_register;
reg [7:0] negated_divisor;
reg [2:0] counter;
reg [7:0] quotient;
reg [7:0] remainder;

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        dividend_reg <= 0;
        divisor_reg <= 0;
        sign_reg <= 0;
        shift_register <= 0;
        negated_divisor <= 0;
        counter <= 0;
        quotient <= 0;
        remainder <= 0;
        res_valid <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    sign_reg <= sign;
                    state <= START;
                end
            end
            START: begin
                if (sign_reg) begin
                    shift_register <= ({dividend_reg[7]? 8'hff : 8'h00} + dividend_reg) << 1;
                    negated_divisor <= ({divisor_reg[7]? 8'hff : 8'h00} + divisor_reg);
                end else begin
                    shift_register <= dividend_reg << 1;
                    negated_divisor <= divisor_reg;
                end
                counter <= 1;
                state <= DIVIDE;
            end
            DIVIDE: begin
                if (counter < 8) begin
                    reg [8:0] subtraction;
                    subtraction = {1'b0, shift_register[15:8]} - negated_divisor;
                    if (subtraction[8]) begin
                        shift_register <= {1'b0, shift_register[15:8]} << 1;
                    end else begin
                        shift_register <= {1'b1, shift_register[15:8]} + (negated_divisor << 1);
                    end
                    counter <= counter + 1;
                end else begin
                    quotient <= shift_register[7:0];
                    remainder <= shift_register[15:8];
                    state <= OUTPUT;
                end
            end
            OUTPUT: begin
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

// Assign the result
always @(*) begin
    result = {remainder, quotient};
end

endmodule
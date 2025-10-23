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

// Internal signals
reg [7:0] dividend_reg, divisor_reg;
reg sign_reg;
reg [15:0] shift_register;
reg [7:0] negated_divisor;
reg [2:0] counter;
reg [7:0] quotient;
reg [7:0] remainder;

// Stage 1: Input Stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sign_reg <= 0;
    end else if (opn_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        sign_reg <= sign;
    end
end

// Stage 2: Initialization Stage
reg [15:0] init_shift_register;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        init_shift_register <= 0;
        negated_divisor <= 0;
    end else if (opn_valid) begin
        if (sign_reg) begin
            init_shift_register <= ({dividend_reg[7]? 8'hff : 8'h00} + dividend_reg) << 1;
            negated_divisor <= ({divisor_reg[7]? 8'hff : 8'h00} + divisor_reg);
        end else begin
            init_shift_register <= dividend_reg << 1;
            negated_divisor <= divisor_reg;
        end
    end
end

// Stage 3: Division Stage
reg [15:0] div_shift_register;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        div_shift_register <= 0;
        counter <= 0;
    end else if (opn_valid && counter < 8) begin
        reg [8:0] subtraction;
        subtraction = {1'b0, div_shift_register[15:8]} - negated_divisor;
        if (subtraction[8]) begin
            div_shift_register <= {1'b0, div_shift_register[15:8]} << 1;
        end else begin
            div_shift_register <= {1'b1, div_shift_register[15:8]} + (negated_divisor << 1);
        end
        counter <= counter + 1;
    end else if (opn_valid && counter == 8) begin
        quotient <= div_shift_register[7:0];
        remainder <= div_shift_register[15:8];
    end
end

// Stage 4: Result Stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        result <= 0;
    end else if (opn_valid && counter == 8) begin
        result <= {remainder, quotient};
    end
end

// Stage 5: Output Stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else if (opn_valid && counter == 8) begin
        res_valid <= 1;
    end else if (~opn_valid) begin
        res_valid <= 0;
    end
end

// Initialize div_shift_register
always @(posedge clk) begin
    if (opn_valid) begin
        div_shift_register <= init_shift_register;
    end
end

endmodule
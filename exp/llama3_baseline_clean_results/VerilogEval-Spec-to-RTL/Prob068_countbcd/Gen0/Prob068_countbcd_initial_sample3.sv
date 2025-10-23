module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
wire [3:0] next_q_ones, next_q_tens, next_q_hundreds, next_q_thousands;
reg [2:0] ena_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_ones <= 4'd0;
        q_tens <= 4'd0;
        q_hundreds <= 4'd0;
        q_thousands <= 4'd0;
        ena_reg <= 3'd0;
    end else begin
        q_ones <= next_q_ones;
        q_tens <= next_q_tens;
        q_hundreds <= next_q_hundreds;
        q_thousands <= next_q_thousands;
        ena_reg <= {next_q_thousands != 4'd0 && next_q_thousands != 4'd1 && next_q_thousands != 4'd2 && next_q_thousands != 4'd3 && next_q_thousands != 4'd4 && next_q_thousands != 4'd5 && next_q_thousands != 4'd6 && next_q_thousands != 4'd7 && next_q_thousands != 4'd8 && next_q_thousands != 4'd9,
                     next_q_hundreds != 4'd0 && next_q_hundreds != 4'd1 && next_q_hundreds != 4'd2 && next_q_hundreds != 4'd3 && next_q_hundreds != 4'd4 && next_q_hundreds != 4'd5 && next_q_hundreds != 4'd6 && next_q_hundreds != 4'd7 && next_q_hundreds != 4'd8 && next_q_hundreds != 4'd9,
                     next_q_tens != 4'd0 && next_q_tens != 4'd1 && next_q_tens != 4'd2 && next_q_tens != 4'd3 && next_q_tens != 4'd4 && next_q_tens != 4'd5 && next_q_tens != 4'd6 && next_q_tens != 4'd7 && next_q_tens != 4'd8 && next_q_tens != 4'd9};
    end
end

always @* begin
    next_q_ones = q_ones + 1;
    next_q_tens = q_tens;
    next_q_hundreds = q_hundreds;
    next_q_thousands = q_thousands;

    if (q_ones == 4'd9) begin
        next_q_ones = 4'd0;
        next_q_tens = q_tens + 1;
    end

    if (q_tens == 4'd9 && q_ones == 4'd9) begin
        next_q_tens = 4'd0;
        next_q_hundreds = q_hundreds + 1;
    end

    if (q_hundreds == 4'd9 && q_tens == 4'd9 && q_ones == 4'd9) begin
        next_q_hundreds = 4'd0;
        next_q_thousands = q_thousands + 1;
    end

    if (q_thousands == 4'd9 && q_hundreds == 4'd9 && q_tens == 4'd9 && q_ones == 4'd9) begin
        next_q_thousands = 4'd0;
        next_q_hundreds = 4'd0;
        next_q_tens = 4'd0;
        next_q_ones = 4'd0;
    end
end

assign q = {q_thousands, q_hundreds, q_tens, q_ones};
assign ena = ena_reg;

endmodule
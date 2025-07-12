module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

// Internal signals for the four 4-bit counters
reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
reg [3:0] next_q_ones, next_q_tens, next_q_hundreds, next_q_thousands;

// Output assignments for the enable signals
assign ena[0] = (q_ones == 4'd9) ? 1'b1 : 1'b0;
assign ena[1] = (q_tens == 4'd9 && ena[0] == 1'b1) ? 1'b1 : 1'b0;
assign ena[2] = (q_hundreds == 4'd9 && ena[1] == 1'b1 && ena[0] == 1'b1) ? 1'b1 : 1'b0;

// Next state logic for the 4-bit counters
always @(*) begin
    next_q_ones = q_ones + 1;
    if (q_ones == 4'd9) next_q_ones = 4'd0;

    next_q_tens = q_tens;
    if (ena[0] == 1'b1) begin
        next_q_tens = q_tens + 1;
        if (q_tens == 4'd9) next_q_tens = 4'd0;
    end

    next_q_hundreds = q_hundreds;
    if (ena[1] == 1'b1) begin
        next_q_hundreds = q_hundreds + 1;
        if (q_hundreds == 4'd9) next_q_hundreds = 4'd0;
    end

    next_q_thousands = q_thousands;
    if (ena[2] == 1'b1) begin
        next_q_thousands = q_thousands + 1;
        if (q_thousands == 4'd9) next_q_thousands = 4'd0;
    end
end

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        q_ones <= 4'd0;
        q_tens <= 4'd0;
        q_hundreds <= 4'd0;
        q_thousands <= 4'd0;
    end else begin
        q_ones <= next_q_ones;
        q_tens <= next_q_tens;
        q_hundreds <= next_q_hundreds;
        q_thousands <= next_q_thousands;
    end
end

// Output assignments for the 16-bit output
assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule
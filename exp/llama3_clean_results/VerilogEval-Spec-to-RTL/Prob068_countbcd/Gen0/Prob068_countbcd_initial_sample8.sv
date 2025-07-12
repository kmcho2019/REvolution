module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones;
reg [3:0] q_tens;
reg [3:0] q_hundreds;
reg [3:0] q_thousands;

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
    end else begin
        reg [3:0] next_ones;
        reg [3:0] next_tens;
        reg [3:0] next_hundreds;
        reg [3:0] next_thousands;

        next_ones = q_ones + 1;
        next_tens = q_tens;
        next_hundreds = q_hundreds;
        next_thousands = q_thousands;

        if (next_ones == 10) begin
            next_ones = 0;
            next_tens = q_tens + 1;
        end

        if (next_tens == 10 && next_ones == 0) begin
            next_tens = 0;
            next_hundreds = q_hundreds + 1;
        end

        if (next_hundreds == 10 && next_tens == 0 && next_ones == 0) begin
            next_hundreds = 0;
            next_thousands = q_thousands + 1;
        end

        if (next_thousands == 10 && next_hundreds == 0 && next_tens == 0 && next_ones == 0) begin
            next_thousands = 0;
            next_hundreds = 0;
            next_tens = 0;
            next_ones = 0;
        end

        q_ones <= next_ones;
        q_tens <= next_tens;
        q_hundreds <= next_hundreds;
        q_thousands <= next_thousands;
    end
end

assign ena[0] = (q_ones == 9)? 1'b1 : 1'b0;
assign ena[1] = (q_tens == 9 && q_ones == 0)? 1'b1 : 1'b0;
assign ena[2] = (q_hundreds == 9 && q_tens == 0 && q_ones == 0)? 1'b1 : 1'b0;

endmodule
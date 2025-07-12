module TopModule (
    input       clk,
    input       reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones;
reg [3:0] q_tens;
reg [3:0] q_hundreds;
reg [3:0] q_thousands;

always @(posedge clk or posedge reset) begin
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

        if (q_ones == 9) begin
            next_ones = 0;
            next_tens = q_tens + 1;
        end else begin
            next_tens = q_tens;
        end

        if (q_ones == 9 && q_tens == 9) begin
            next_tens = 0;
            next_hundreds = q_hundreds + 1;
        end else begin
            next_hundreds = q_hundreds;
        end

        if (q_ones == 9 && q_tens == 9 && q_hundreds == 9) begin
            next_hundreds = 0;
            next_thousands = q_thousands + 1;
        end else begin
            next_thousands = q_thousands;
        end

        q_ones <= next_ones;
        q_tens <= next_tens;
        q_hundreds <= next_hundreds;
        q_thousands <= next_thousands;
    end
end

assign q = {q_thousands, q_hundreds, q_tens, q_ones};
assign ena[0] = (q_ones == 9) ? 1'b1 : 1'b0;
assign ena[1] = (q_tens == 9 && q_ones == 9) ? 1'b1 : 1'b0;
assign ena[2] = (q_hundreds == 9 && q_tens == 9 && q_ones == 9) ? 1'b1 : 1'b0;

endmodule
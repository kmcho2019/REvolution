module BCDCounter(
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 0;
    end else if (enable) begin
        if (q == 9) begin
            q <= 0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg ones_carry, tens_carry, hundreds_carry;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
        ones_carry <= 0;
        tens_carry <= 0;
        hundreds_carry <= 0;
    end else begin
        ones_carry <= ones == 9;
        tens_carry <= tens == 9;
        hundreds_carry <= hundreds == 9;

        if (ones == 9) begin
            ones <= 0;
        end else begin
            ones <= ones + 1;
        end

        if (tens_carry) begin
            if (tens == 9) begin
                tens <= 0;
            end else begin
                tens <= tens + 1;
            end
        end

        if (hundreds_carry) begin
            if (hundreds == 9) begin
                hundreds <= 0;
            end else begin
                hundreds <= hundreds + 1;
            end
        end

        if (ones_carry && tens_carry && hundreds_carry) begin
            if (thousands == 9) begin
                thousands <= 0;
            end else begin
                thousands <= thousands + 1;
            end
        end
    end
end

always @(*) begin
    ena[0] = ones_carry;
    ena[1] = tens_carry;
    ena[2] = hundreds_carry;
    q[3:0] = ones;
    q[7:4] = tens;
    q[11:8] = hundreds;
    q[15:12] = thousands;
end

endmodule
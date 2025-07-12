module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit_ones;
    reg [3:0] digit_tens;
    reg [3:0] digit_hundreds;
    reg [3:0] digit_thousands;

    assign q = {digit_thousands, digit_hundreds, digit_tens, digit_ones};
    assign ena[0] = (digit_ones == 4'd9);
    assign ena[1] = (digit_tens == 4'd9) && (digit_ones == 4'd9);
    assign ena[2] = (digit_hundreds == 4'd9) && (digit_tens == 4'd9) && (digit_ones == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            digit_ones <= 0;
            digit_tens <= 0;
            digit_hundreds <= 0;
            digit_thousands <= 0;
        end else begin
            if (ena[0]) begin
                digit_ones <= 0;
                if (ena[1]) begin
                    digit_tens <= 0;
                    if (ena[2]) begin
                        digit_hundreds <= 0;
                        digit_thousands <= digit_thousands + 1;
                    end else begin
                        digit_hundreds <= digit_hundreds + 1;
                    end
                end else begin
                    digit_tens <= digit_tens + 1;
                end
            end else begin
                digit_ones <= digit_ones + 1;
            end
        end
    end

endmodule
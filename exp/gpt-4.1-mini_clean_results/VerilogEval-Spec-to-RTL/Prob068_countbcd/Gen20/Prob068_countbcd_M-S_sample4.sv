module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    wire carry_ones = (ones == 4'd9);
    wire carry_tens = (tens == 4'd9);
    wire carry_hundreds = (hundreds == 4'd9);

    // Enable signals indicate when the next digit should increment
    assign ena[0] = carry_ones;
    assign ena[1] = carry_ones & carry_tens;
    assign ena[2] = carry_ones & carry_tens & carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            if (carry_ones) begin
                ones <= 4'd0;
                if (carry_tens) begin
                    tens <= 4'd0;
                    if (carry_hundreds) begin
                        hundreds <= 4'd0;
                        if (thousands == 4'd9)
                            thousands <= 4'd0;
                        else
                            thousands <= thousands + 4'd1;
                    end else
                        hundreds <= hundreds + 4'd1;
                end else
                    tens <= tens + 4'd1;
            end else
                ones <= ones + 4'd1;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
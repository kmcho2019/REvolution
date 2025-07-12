module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    wire carry_ones, carry_tens, carry_hundreds;

    // Determine if ones digit will roll over
    assign carry_ones = (ones == 4'd9);
    // Carry into tens digit depends on ones rollover
    assign carry_tens = carry_ones && (tens == 4'd9);
    // Carry into hundreds digit depends on tens rollover
    assign carry_hundreds = carry_tens && (hundreds == 4'd9);

    // Enables for incrementing upper digits: asserted when lower digit rolls from 9 to 0
    assign ena[0] = carry_ones;
    assign ena[1] = carry_tens;
    assign ena[2] = carry_hundreds;

    // Compute next digit values in parallel
    wire [3:0] ones_next;
    wire [3:0] tens_next;
    wire [3:0] hundreds_next;
    wire [3:0] thousands_next;

    assign ones_next = (carry_ones) ? 4'd0 : (ones + 1'b1);
    assign tens_next = (carry_tens) ? 4'd0 : (carry_ones ? tens + 1'b1 : tens);
    assign hundreds_next = (carry_hundreds) ? 4'd0 : (carry_tens ? hundreds + 1'b1 : hundreds);
    assign thousands_next = (carry_hundreds && (thousands == 4'd9)) ? 4'd0 :
                           (carry_hundreds ? thousands + 1'b1 : thousands);

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones      <= ones_next;
            tens      <= tens_next;
            hundreds  <= hundreds_next;
            thousands <= thousands_next;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
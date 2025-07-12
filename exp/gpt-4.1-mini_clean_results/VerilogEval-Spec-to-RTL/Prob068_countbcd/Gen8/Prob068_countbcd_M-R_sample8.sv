module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire       c1, c2, c3; // carry signals between digits

    // Increment logic for BCD digit with carry out
    // If digit == 9, next digit resets to 0 with carry = 1; else digit+1, carry=0
    function [4:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = {1'b1, 4'd0};
            else
                bcd_inc = {1'b0, digit + 1'b1};
        end
    endfunction

    // Combinational next states and carry signals
    wire [4:0] ones_next = bcd_inc(ones);
    wire [4:0] tens_next = bcd_inc(tens);
    wire [4:0] hundreds_next = bcd_inc(hundreds);
    wire [4:0] thousands_next = bcd_inc(thousands);

    // Enable signals for higher digits are carry out from lower digits
    assign ena[0] = ones_next[4];
    assign ena[1] = ena[0] && tens_next[4];
    assign ena[2] = ena[1] && hundreds_next[4];

    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands <=4'd0;
        end else begin
            // Always increment ones digit
            ones <= ones_next[3:0];

            // Increment tens only if ones digit rolled over
            if (ones_next[4])
                tens <= tens_next[3:0];

            // Increment hundreds only if tens digit rolled over
            if (ena[1])
                hundreds <= hundreds_next[3:0];

            // Increment thousands only if hundreds digit rolled over
            if (ena[2])
                thousands <= thousands_next[3:0];
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Function: increment a BCD digit by 1 with carry out
    function [4:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = {1'b1, 4'd0}; // carry out with reset digit
            else
                bcd_inc = {1'b0, digit + 1'b1};
        end
    endfunction

    // Calculate carry out from each digit combinationally (Example 1 style)
    wire carry_0 = (ones == 4'd9);
    wire carry_1 = carry_0 && (tens == 4'd9);
    wire carry_2 = carry_1 && (hundreds == 4'd9);

    // ena bits combinationally indicate when upper digits should increment
    assign ena = {carry_2, carry_1, carry_0};

    // Calculate next values for each digit conditionally
    wire [4:0] next_ones     = bcd_inc(ones);                    // always increment ones
    wire [4:0] next_tens     = carry_0 ? bcd_inc(tens)     : {1'b0, tens};
    wire [4:0] next_hundreds = carry_1 ? bcd_inc(hundreds) : {1'b0, hundreds};
    wire [4:0] next_thousands= carry_2 ? bcd_inc(thousands): {1'b0, thousands};

    // Sequential update with gated updates to minimize toggling
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones always increment
            ones <= next_ones[3:0];

            // Tens increments only if ones roll over
            if (carry_0)
                tens <= next_tens[3:0];

            // Hundreds increments only if tens roll over
            if (carry_1)
                hundreds <= next_hundreds[3:0];

            // Thousands increments only if hundreds roll over
            if (carry_2)
                thousands <= next_thousands[3:0];
        end
    end

    // Concatenate digits for output
    assign q = {thousands, hundreds, tens, ones};

endmodule
module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Generate enable signals for upper digits based on current digit values
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Compute carry signals combinationally for each digit increment
    wire carry_ones = (ones == 4'd9);
    wire carry_tens = carry_ones && (tens == 4'd9);
    wire carry_hundreds = carry_tens && (hundreds == 4'd9);

    // Next digit values if incremented (helper function)
    function [3:0] bcd_next;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_next = 4'd0;
            else
                bcd_next = digit + 4'd1;
        end
    endfunction

    // Update registers on clock edge with clock enable gating for upper digits
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Always increment ones digit
            ones <= bcd_next(ones);

            // Increment tens only if carry from ones
            if (carry_ones)
                tens <= bcd_next(tens);

            // Increment hundreds only if carry from tens
            if (carry_tens)
                hundreds <= bcd_next(hundreds);

            // Increment thousands only if carry from hundreds
            if (carry_hundreds)
                thousands <= bcd_next(thousands);
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
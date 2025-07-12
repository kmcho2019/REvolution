module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg [2:0] ena_reg;

    // Detect rollover combinationally: true when digit is 9
    wire ones_rollover     = (ones == 4'd9);
    wire tens_rollover     = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);

    // Outputs ena indicate when upper digit should increment,
    // registered for synchronous timing alignment.
    assign ena = ena_reg;

    // Increment helper function for BCD digit
    function [3:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = 4'd0;
            else
                bcd_increment = digit + 1'b1;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena_reg   <= 3'b0;
        end else begin
            // Increment ones digit every cycle
            ones <= bcd_increment(ones);

            // Increment tens if ones digit is rolling over
            if (ones_rollover)
                tens <= bcd_increment(tens);

            // Increment hundreds if tens digit is rolling over and ones rolled over
            if (ones_rollover && tens_rollover)
                hundreds <= bcd_increment(hundreds);

            // Increment thousands if hundreds, tens, and ones digits all rolled over
            if (ones_rollover && tens_rollover && hundreds_rollover)
                thousands <= bcd_increment(thousands);

            // Register the enables indicating which upper digits increment this cycle
            ena_reg[0] <= ones_rollover;                           // enable tens increment
            ena_reg[1] <= ones_rollover & tens_rollover;           // enable hundreds increment
            ena_reg[2] <= ones_rollover & tens_rollover & hundreds_rollover; // enable thousands increment
        end
    end

    // Pack digits into 16-bit output q as thousands:tens:hundreds:ones
    assign q = {thousands, hundreds, tens, ones};

endmodule
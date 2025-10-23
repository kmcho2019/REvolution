module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals: tens enabled when ones rolls over from 9 to 0, etc.
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);

    assign ena[0] = ones_rollover;     // enable tens increment
    assign ena[1] = tens_rollover;     // enable hundreds increment
    assign ena[2] = hundreds_rollover; // enable thousands increment

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit, rollover at 9
            if (ones_rollover)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            // Increment tens if ones rolled over, else hold
            if (ones_rollover) begin
                if (tens_rollover)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Increment hundreds if tens rolled over, else hold
            if (tens_rollover) begin
                if (hundreds_rollover)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Increment thousands if hundreds rolled over, else hold
            if (hundreds_rollover) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
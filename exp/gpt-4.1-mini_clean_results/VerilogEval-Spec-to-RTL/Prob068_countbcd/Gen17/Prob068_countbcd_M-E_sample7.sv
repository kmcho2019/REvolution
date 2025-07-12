module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Signals to indicate carry from previous digit at the current clock
    reg carry_ones, carry_tens, carry_hundreds;

    // Enable signals indicate when digits 1,2,3 should increment on this cycle
    // Digit 1 (tens) increments when ones rolled over from 9->0 last cycle (carry_ones)
    assign ena[0] = carry_ones;
    // Digit 2 (hundreds) increments when tens rolled over (carry_tens)
    assign ena[1] = carry_tens;
    // Digit 3 (thousands) increments when hundreds rolled over (carry_hundreds)
    assign ena[2] = carry_hundreds;

    // Pack BCD digits into q output
    assign q = {thousands, hundreds, tens, ones};

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            carry_ones     <= 1'b0;
            carry_tens     <= 1'b0;
            carry_hundreds <= 1'b0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                ones      <= 4'd0;
                carry_ones <= 1'b1;
            end else begin
                ones      <= ones + 1'b1;
                carry_ones <= 1'b0;
            end

            // Increment tens digit if carry_ones was set on previous cycle
            if (carry_ones) begin
                if (tens == 4'd9) begin
                    tens      <= 4'd0;
                    carry_tens <= 1'b1;
                end else begin
                    tens      <= tens + 1'b1;
                    carry_tens <= 1'b0;
                end
            end else begin
                carry_tens <= 1'b0;
            end

            // Increment hundreds digit if carry_tens was set on previous cycle
            if (carry_tens) begin
                if (hundreds == 4'd9) begin
                    hundreds  <= 4'd0;
                    carry_hundreds <= 1'b1;
                end else begin
                    hundreds  <= hundreds + 1'b1;
                    carry_hundreds <= 1'b0;
                end
            end else begin
                carry_hundreds <= 1'b0;
            end

            // Increment thousands digit if carry_hundreds was set on previous cycle
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                    // No further carry needed beyond thousands digit
                end else begin
                    thousands <= thousands + 1'b1;
                end
            end
            // No carry signal needed for thousands digit
        end
    end

endmodule
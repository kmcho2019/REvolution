module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    reg carry_ones_to_tens;
    reg carry_tens_to_hundreds;
    reg carry_hundreds_to_thousands;

    // ena signals are the carry enables indicating when upper digits increment
    assign ena[0] = carry_ones_to_tens;
    assign ena[1] = carry_tens_to_hundreds;
    assign ena[2] = carry_hundreds_to_thousands;

    // Concatenate all digits into a 16-bit output
    assign q = {thousands, hundreds, tens, ones};

    always @(posedge clk) begin
        if (reset) begin
            ones               <= 4'd0;
            tens               <= 4'd0;
            hundreds           <= 4'd0;
            thousands          <= 4'd0;
            carry_ones_to_tens     <= 1'b0;
            carry_tens_to_hundreds <= 1'b0;
            carry_hundreds_to_thousands <= 1'b0;
        end else begin
            // Default: clear carries first
            carry_ones_to_tens     <= 1'b0;
            carry_tens_to_hundreds <= 1'b0;
            carry_hundreds_to_thousands <= 1'b0;

            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                carry_ones_to_tens <= 1'b1;
            end else begin
                ones <= ones + 1'b1;
            end

            // Increment tens digit if carry from ones
            if (carry_ones_to_tens) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    carry_tens_to_hundreds <= 1'b1;
                end else begin
                    tens <= tens + 1'b1;
                end
            end

            // Increment hundreds digit if carry from tens
            if (carry_tens_to_hundreds) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    carry_hundreds_to_thousands <= 1'b1;
                end else begin
                    hundreds <= hundreds + 1'b1;
                end
            end

            // Increment thousands digit if carry from hundreds
            if (carry_hundreds_to_thousands) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0; // roll over after 9999 to 0000
                end else begin
                    thousands <= thousands + 1'b1;
                end
            end
        end
    end

endmodule
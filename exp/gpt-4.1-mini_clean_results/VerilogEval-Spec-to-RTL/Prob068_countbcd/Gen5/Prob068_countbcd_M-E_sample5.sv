module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Helper function to increment a BCD digit with wrap-around and carry out
    function automatic [4:0] bcd_increment;
        input [3:0] digit;
        reg [4:0] result;
        begin
            if (digit == 4'd9)
                result = {1'b1, 4'd0}; // carry out, digit wrapped to 0
            else
                result = {1'b0, digit + 1'b1}; // no carry, digit incremented
            bcd_increment = result;
        end
    endfunction

    reg [3:0] ones, tens, hundreds, thousands;
    reg carry_ones, carry_tens, carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            q         <= 16'd0;
            ena       <= 3'b000;
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            carry_ones <= 1'b0;
            carry_tens <= 1'b0;
            carry_hundreds <= 1'b0;
        end else begin
            // Increment ones digit
            {carry_ones, ones} = bcd_increment(ones);

            // Increment tens digit if ones carried out
            if (carry_ones) begin
                {carry_tens, tens} = bcd_increment(tens);
            end else begin
                carry_tens = 1'b0;
            end

            // Increment hundreds digit if tens carried out
            if (carry_tens) begin
                {carry_hundreds, hundreds} = bcd_increment(hundreds);
            end else begin
                carry_hundreds = 1'b0;
            end

            // Increment thousands digit if hundreds carried out
            if (carry_hundreds) begin
                // Wrap around thousands digit after 9
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end

            // Set ena signals indicating increments on upper digits
            ena[0] <= carry_ones;       // Enable tens increment
            ena[1] <= carry_tens;       // Enable hundreds increment
            ena[2] <= carry_hundreds;   // Enable thousands increment

            // Update output q with all digits concatenated
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule
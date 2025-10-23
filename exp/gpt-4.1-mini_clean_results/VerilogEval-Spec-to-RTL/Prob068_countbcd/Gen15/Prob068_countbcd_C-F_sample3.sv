module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    // Separate 4-bit registers for each BCD digit
    reg [3:0] ones, tens, hundreds, thousands;

    // Function to increment a BCD digit with carry out
    function [4:0] bcd_increment;
        input [3:0] digit_in;
        begin
            if (digit_in == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry = 1, digit reset to 0
            else
                bcd_increment = {1'b0, digit_in + 1'b1}; // carry = 0, digit + 1
        end
    endfunction

    // Enable signals indicate when each upper digit should increment
    assign ena[0] = (ones == 4'd9);               // Tens increments when ones rolls over
    assign ena[1] = ena[0] && (tens == 4'd9);     // Hundreds increments when tens rolls over and ones rollover
    assign ena[2] = ena[1] && (hundreds == 4'd9); // Thousands increments when hundreds rolls over and tens rollover

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit
            reg carry_ones;
            reg carry_tens;
            reg carry_hundreds;
            reg carry_thousands;
            reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;

            {carry_ones, ones_next} = bcd_increment(ones);

            if (carry_ones) begin
                {carry_tens, tens_next} = bcd_increment(tens);
            end else begin
                carry_tens = 1'b0;
                tens_next = tens;
            end

            if (carry_tens) begin
                {carry_hundreds, hundreds_next} = bcd_increment(hundreds);
            end else begin
                carry_hundreds = 1'b0;
                hundreds_next = hundreds;
            end

            if (carry_hundreds) begin
                {carry_thousands, thousands_next} = bcd_increment(thousands);
            end else begin
                carry_thousands = 1'b0;
                thousands_next = thousands;
            end

            // Update registers non-blocking
            ones      <= ones_next;
            tens      <= tens_next;
            hundreds  <= hundreds_next;
            thousands <= thousands_next;
        end
    end

    // Pack digits into output vector
    assign q = {thousands, hundreds, tens, ones};

endmodule
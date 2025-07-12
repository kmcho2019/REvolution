module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Extract digits for combinational enable signals
    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Enable signals indicate when upper digits should increment
    // ena[0] - enable tens increment (ones digit rolls over)
    // ena[1] - enable hundreds increment (tens digit rolls over when ones rolled over)
    // ena[2] - enable thousands increment (hundreds digit rolls over when tens and ones rolled over)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) && ena[0];
    assign ena[2] = (hundreds == 4'd9) && ena[1];

    // Function to increment a single BCD digit with carry out
    // Returns {carry_out, digit_plus_1}
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry out, reset digit to 0
            else
                bcd_increment = {1'b0, digit + 1'b1}; // no carry, digit+1
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            reg carry;
            reg [3:0] new_ones, new_tens, new_hundreds, new_thousands;

            // Increment ones digit
            {carry, new_ones} = bcd_increment(ones);

            // Increment tens if carry from ones
            if (carry) begin
                {carry, new_tens} = bcd_increment(tens);
            end else begin
                new_tens = tens;
                carry = 1'b0;
            end

            // Increment hundreds if carry from tens
            if (carry) begin
                {carry, new_hundreds} = bcd_increment(hundreds);
            end else begin
                new_hundreds = hundreds;
                carry = 1'b0;
            end

            // Increment thousands if carry from hundreds
            if (carry) begin
                {carry, new_thousands} = bcd_increment(thousands);
            end else begin
                new_thousands = thousands;
                carry = 1'b0;
            end

            bcd_count <= {new_thousands, new_hundreds, new_tens, new_ones};
        end
    end

    assign q = bcd_count;

endmodule
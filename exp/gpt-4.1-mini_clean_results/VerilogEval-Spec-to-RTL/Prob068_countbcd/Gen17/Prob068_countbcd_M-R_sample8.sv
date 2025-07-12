module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Enable signals: when each upper digit should increment
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Function to increment one BCD digit with carry out
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0};  // carry out, digit rolls over to 0
            else
                bcd_increment = {1'b0, digit + 1'b1}; // no carry, digit +1
        end
    endfunction

    // Function to increment the full 16-bit BCD count
    // Returns the new 16-bit count after increment
    function [15:0] bcd_count_increment;
        input [15:0] current_count;
        reg [4:0] inc_ones, inc_tens, inc_hundreds, inc_thousands;
        reg [3:0] new_ones, new_tens, new_hundreds, new_thousands;
        reg carry;

        begin
            // Increment ones digit
            inc_ones = bcd_increment(current_count[3:0]);
            new_ones = inc_ones[3:0];
            carry = inc_ones[4];

            // Increment tens digit if carry
            if (carry) begin
                inc_tens = bcd_increment(current_count[7:4]);
                new_tens = inc_tens[3:0];
                carry = inc_tens[4];
            end else begin
                new_tens = current_count[7:4];
                carry = 0;
            end

            // Increment hundreds digit if carry
            if (carry) begin
                inc_hundreds = bcd_increment(current_count[11:8]);
                new_hundreds = inc_hundreds[3:0];
                carry = inc_hundreds[4];
            end else begin
                new_hundreds = current_count[11:8];
                carry = 0;
            end

            // Increment thousands digit if carry
            if (carry) begin
                inc_thousands = bcd_increment(current_count[15:12]);
                new_thousands = inc_thousands[3:0];
                // Ignore carry out of thousands for simplicity
            end else begin
                new_thousands = current_count[15:12];
            end

            bcd_count_increment = {new_thousands, new_hundreds, new_tens, new_ones};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            bcd_count <= bcd_count_increment(bcd_count);
        end
    end

    assign q = bcd_count;

endmodule
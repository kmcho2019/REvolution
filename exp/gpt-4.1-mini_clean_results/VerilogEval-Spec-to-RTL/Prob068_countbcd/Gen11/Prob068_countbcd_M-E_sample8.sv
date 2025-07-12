module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);
    // 16-bit binary counter
    reg [15:0] bin_cnt;

    // Registered BCD digits from previous cycle for enable generation
    reg [3:0] prev_ones, prev_tens, prev_hundreds, prev_thousands;

    // Current BCD digits (combinational from bin_cnt)
    wire [3:0] ones, tens, hundreds, thousands;

    // Binary to BCD conversion using Double Dabble algorithm
    // Implemented as a combinational function
    function [15:0] bin_to_bcd;
        input [15:0] binary;
        integer i;
        reg [27:0] shift_reg; // 16 + 3*4 bits = 28 bits
        begin
            shift_reg = 28'd0;
            shift_reg[15:0] = binary;

            for (i = 0; i < 16; i = i + 1) begin
                // For each 4-bit BCD digit, add 3 if >= 5
                if (shift_reg[19:16] >= 5)
                    shift_reg[19:16] = shift_reg[19:16] + 3;
                if (shift_reg[23:20] >= 5)
                    shift_reg[23:20] = shift_reg[23:20] + 3;
                if (shift_reg[27:24] >= 5)
                    shift_reg[27:24] = shift_reg[27:24] + 3;

                // Shift left by 1
                shift_reg = shift_reg << 1;
            end

            // Output BCD digits packed: thousands[27:24], hundreds[23:20], tens[19:16], ones[15:12]
            bin_to_bcd = {shift_reg[27:24], shift_reg[23:20], shift_reg[19:16], shift_reg[15:12]};
        end
    endfunction

    wire [15:0] bcd_digits = bin_to_bcd(bin_cnt);

    assign {thousands, hundreds, tens, ones} = bcd_digits;

    // Generate enable signals on rising edge when digit rolls over 9->0
    // ena[0] - enable for tens digit (digit 1)
    // ena[1] - enable for hundreds digit (digit 2)
    // ena[2] - enable for thousands digit (digit 3)

    // Digit rollover detection: when previous digit is 9 and current digit is 0
    wire ones_rollover     = (prev_ones == 4'd9)     && (ones == 4'd0);
    wire tens_rollover     = (prev_tens == 4'd9)     && (tens == 4'd0);
    wire hundreds_rollover = (prev_hundreds == 4'd9) && (hundreds == 4'd0);

    assign ena[0] = ones_rollover;                 // tens enable
    assign ena[1] = ones_rollover & tens_rollover;       // hundreds enable
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover; // thousands enable

    always @(posedge clk) begin
        if (reset) begin
            bin_cnt <= 16'd0;
            prev_ones <= 4'd0;
            prev_tens <= 4'd0;
            prev_hundreds <= 4'd0;
            prev_thousands <= 4'd0;
        end else begin
            bin_cnt <= bin_cnt + 16'd1;

            // Register current BCD digits for next cycle's rollover detection
            prev_ones      <= ones;
            prev_tens      <= tens;
            prev_hundreds  <= hundreds;
            prev_thousands <= thousands;
        end
    end

    assign q = bcd_digits;

endmodule
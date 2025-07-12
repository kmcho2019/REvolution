module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Extract digits for combinational logic
    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Combinational enable signals indicate when upper digits should increment
    // i.e. when lower digit is about to roll over from 9 to 0
    assign ena[0] = (ones == 4'd9);                        // enable tens increment
    assign ena[1] = ena[0] && (tens == 4'd9);              // enable hundreds increment
    assign ena[2] = ena[1] && (hundreds == 4'd9);          // enable thousands increment

    // Function to increment a BCD digit by 1 with carry-out
    function [4:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = {1'b1, 4'd0}; // carry-out and reset digit to 0
            else
                bcd_inc = {1'b0, digit + 1'b1}; // no carry, digit + 1
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            reg [4:0] inc_ones, inc_tens, inc_hundreds, inc_thousands;

            // Increment ones digit
            inc_ones = bcd_inc(ones);

            if (inc_ones[4]) begin
                // Ones rolled over, increment tens
                inc_tens = bcd_inc(tens);
                if (inc_tens[4]) begin
                    // Tens rolled over, increment hundreds
                    inc_hundreds = bcd_inc(hundreds);
                    if (inc_hundreds[4]) begin
                        // Hundreds rolled over, increment thousands
                        inc_thousands = bcd_inc(thousands);
                        bcd_count <= {inc_thousands[3:0], inc_hundreds[3:0], inc_tens[3:0], inc_ones[3:0]};
                    end else begin
                        // Hundreds did not roll over
                        bcd_count <= {thousands, inc_hundreds[3:0], inc_tens[3:0], inc_ones[3:0]};
                    end
                end else begin
                    // Tens did not roll over
                    bcd_count <= {thousands, hundreds, inc_tens[3:0], inc_ones[3:0]};
                end
            end else begin
                // Ones did not roll over
                bcd_count <= {thousands, hundreds, tens, inc_ones[3:0]};
            end
        end
    end

    assign q = bcd_count;

endmodule
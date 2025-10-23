module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

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

    // Compute enable signals combinationally: 
    // ena[0]: tens increments when ones == 9 (ones will roll over)
    // ena[1]: hundreds increments when tens == 9 and tens increments
    // ena[2]: thousands increments when hundreds == 9 and hundreds increments
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Combinational increment with carry ripple chain
    wire [4:0] inc_ones      = bcd_increment(ones);
    wire [4:0] inc_tens      = bcd_increment(tens);
    wire [4:0] inc_hundreds  = bcd_increment(hundreds);
    wire [4:0] inc_thousands = bcd_increment(thousands);

    // Prepare next states by ripple carry:
    // 1) Increment ones always.
    // 2) If ones rolled over (carry), increment tens.
    // 3) If tens rolled over and tens incremented, increment hundreds.
    // 4) If hundreds rolled over and hundreds incremented, increment thousands.
    // Otherwise keep digit unchanged.

    reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;

    always @* begin
        ones_next = inc_ones[3:0];

        if (inc_ones[4]) begin // carry from ones
            // increment tens
            if (inc_tens[4]) begin // carry from tens
                // increment hundreds
                if (inc_hundreds[4]) begin // carry from hundreds
                    thousands_next = inc_thousands[3:0];
                end else begin
                    thousands_next = thousands;
                end
                hundreds_next = inc_hundreds[3:0];
            end else begin
                hundreds_next = hundreds;
                thousands_next = thousands;
            end
            tens_next = inc_tens[3:0];
        end else begin
            tens_next = tens;
            hundreds_next = hundreds;
            thousands_next = thousands;
        end
    end

    // Synchronous update of registers
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones      <= ones_next;
            tens      <= tens_next;
            hundreds  <= hundreds_next;
            thousands <= thousands_next;
        end
    end

    // Pack digits into output vector
    assign q = {thousands, hundreds, tens, ones};

endmodule
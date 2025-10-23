module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Function: increment a BCD digit with carry out
    function [4:0] bcd_inc;
        input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_inc = {1'b1, 4'd0}; // carry out, digit resets to 0
        else
            bcd_inc = {1'b0, digit + 1'b1};
    end
    endfunction

    // Combinational increments and carry detection
    wire [4:0] inc_ones     = bcd_inc(ones);
    wire [4:0] inc_tens     = (inc_ones[4]) ? bcd_inc(tens) : {1'b0, tens};
    wire [4:0] inc_hundreds = (inc_tens[4]) ? bcd_inc(hundreds) : {1'b0, hundreds};
    wire [4:0] inc_thousands= (inc_hundreds[4]) ? bcd_inc(thousands) : {1'b0, thousands};

    // ena signals are combinational: indicate when the upper digit should increment
    // i.e., when the previous digit will roll over (digit == 9)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Sequential update with conditional digit increments to minimize toggling
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Update ones digit unconditionally
            ones <= inc_ones[3:0];

            // Update tens only if ones rolled over
            if (inc_ones[4])
                tens <= inc_tens[3:0];

            // Update hundreds only if tens rolled over
            if (inc_tens[4])
                hundreds <= inc_hundreds[3:0];

            // Update thousands only if hundreds rolled over
            if (inc_hundreds[4])
                thousands <= inc_thousands[3:0];
        end
    end

    // Concatenate digits for output
    assign q = {thousands, hundreds, tens, ones};

endmodule
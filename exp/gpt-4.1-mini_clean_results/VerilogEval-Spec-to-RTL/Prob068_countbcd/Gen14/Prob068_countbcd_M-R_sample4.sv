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

    // ena signals assert when the lower digit is 9, indicating next digit increment
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Function to increment a BCD digit and output carry
    function [4:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = {1'b1, 4'd0};
            else
                bcd_inc = {1'b0, digit + 1'b1};
        end
    endfunction

    // Precompute increments and carries for ones digit
    wire [4:0] inc_ones = bcd_inc(ones);

    // Precompute increments and carries for tens digit, only if carry from ones
    wire [4:0] inc_tens = bcd_inc(tens);
    wire [3:0] next_tens  = inc_ones[4] ? inc_tens[3:0] : tens;
    wire       carry_tens = inc_ones[4] ? inc_tens[4] : 1'b0;

    // Precompute increments and carries for hundreds digit, only if carry from tens
    wire [4:0] inc_hundreds = bcd_inc(hundreds);
    wire [3:0] next_hundreds  = carry_tens ? inc_hundreds[3:0] : hundreds;
    wire       carry_hundreds = carry_tens ? inc_hundreds[4] : 1'b0;

    // Precompute increments and carries for thousands digit, only if carry from hundreds
    wire [4:0] inc_thousands = bcd_inc(thousands);
    wire [3:0] next_thousands = carry_hundreds ? inc_thousands[3:0] : thousands;

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            bcd_count <= {next_thousands, next_hundreds, next_tens, inc_ones[3:0]};
        end
    end

    assign q = bcd_count;

endmodule
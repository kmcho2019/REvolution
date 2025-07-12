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

    // Generate enable signals for incrementing upper digits
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) && ena[0];
    assign ena[2] = (hundreds == 4'd9) && ena[1];

    // Combinational increment with carry function for a single BCD digit
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry out, reset digit
            else
                bcd_increment = {1'b0, digit + 1'b1}; // no carry, increment digit
        end
    endfunction

    // Next state logic
    wire [4:0] inc_ones      = bcd_increment(ones);
    wire [4:0] inc_tens      = bcd_increment(tens);
    wire [4:0] inc_hundreds  = bcd_increment(hundreds);
    wire [4:0] inc_thousands = bcd_increment(thousands);

    wire       carry_ones      = inc_ones[4];
    wire       carry_tens      = carry_ones && (tens == 4'd9);
    wire       carry_hundreds  = carry_tens && (hundreds == 4'd9);

    wire [3:0] next_ones      = inc_ones[3:0];
    wire [3:0] next_tens      = carry_ones ? inc_tens[3:0] : tens;
    wire [3:0] next_hundreds  = carry_tens ? inc_hundreds[3:0] : hundreds;
    wire [3:0] next_thousands = carry_hundreds ? inc_thousands[3:0] : thousands;

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'b0;
        end else begin
            bcd_count <= {next_thousands, next_hundreds, next_tens, next_ones};
        end
    end

    assign q = bcd_count;

endmodule
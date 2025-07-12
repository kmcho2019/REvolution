module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    wire ones_carry     = (ones == 4'd9);
    wire tens_carry     = (tens == 4'd9);
    wire hundreds_carry = (hundreds == 4'd9);

    wire [3:0] next_ones      = ones_carry ? 4'd0 : (ones + 4'd1);
    wire [3:0] next_tens      = ones_carry ? (tens_carry ? 4'd0 : tens + 4'd1) : tens;
    wire [3:0] next_hundreds  = (ones_carry && tens_carry) ? (hundreds_carry ? 4'd0 : hundreds + 4'd1) : hundreds;
    wire [3:0] next_thousands = (ones_carry && tens_carry && hundreds_carry) ?
                               (thousands == 4'd9 ? 4'd0 : thousands + 4'd1) : thousands;

    assign ena[0] = ones_carry;
    assign ena[1] = ones_carry & tens_carry;
    assign ena[2] = ena[1] & hundreds_carry;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones      <= next_ones;
            tens      <= next_tens;
            hundreds  <= next_hundreds;
            thousands <= next_thousands;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Compute carry signals and next digit values combinationally
    wire carry_0 = (ones == 4'd9);
    wire carry_1 = carry_0 && (tens == 4'd9);
    wire carry_2 = carry_1 && (hundreds == 4'd9);
    wire carry_3 = carry_2 && (thousands == 4'd9);

    wire [3:0] next_ones     = carry_0 ? 4'd0 : (ones + 4'd1);
    wire [3:0] next_tens     = carry_0 ? (carry_1 ? 4'd0 : tens + 4'd1) : tens;
    wire [3:0] next_hundreds = carry_1 ? (carry_2 ? 4'd0 : hundreds + 4'd1) : hundreds;
    wire [3:0] next_thousands= carry_2 ? (carry_3 ? 4'd0 : thousands + 4'd1) : thousands;

    // ena signals correspond to increment enables for tens, hundreds, thousands digits
    assign ena[0] = carry_0; // enable tens digit increment
    assign ena[1] = carry_1; // enable hundreds digit increment
    assign ena[2] = carry_2; // enable thousands digit increment

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

    // Concatenate digits into 16-bit output
    assign q = {thousands, hundreds, tens, ones};

endmodule
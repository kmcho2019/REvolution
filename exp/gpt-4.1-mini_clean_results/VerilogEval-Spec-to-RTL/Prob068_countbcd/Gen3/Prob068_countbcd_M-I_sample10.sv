module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Calculate carry out from each digit - combinational
    wire carry_0 = (ones == 4'd9);
    wire carry_1 = carry_0 & (tens == 4'd9);
    wire carry_2 = carry_1 & (hundreds == 4'd9);
    // carry_3 not needed since no upper digit after thousands

    // ena bits indicate when each upper digit should increment
    assign ena = {carry_2, carry_1, carry_0};

    // Enable update signals for each digit
    wire ones_en = 1'b1;                 // ones always increment
    wire tens_en = carry_0;              // tens increment when ones roll over
    wire hundreds_en = carry_1;          // hundreds increment when tens roll over
    wire thousands_en = carry_2;         // thousands increment when hundreds roll over

    // Next values for digits, increment only if enabled
    wire [4:0] ones_plus = {1'b0, ones} + 5'd1;
    wire [3:0] next_ones = ones_en ? (carry_0 ? 4'd0 : ones + 4'd1) : ones;

    wire [4:0] tens_plus = {1'b0, tens} + 5'd1;
    wire [3:0] next_tens = tens_en ? (carry_1 ? 4'd0 : tens + 4'd1) : tens;

    wire [4:0] hundreds_plus = {1'b0, hundreds} + 5'd1;
    wire [3:0] next_hundreds = hundreds_en ? (carry_2 ? 4'd0 : hundreds + 4'd1) : hundreds;

    wire [4:0] thousands_plus = {1'b0, thousands} + 5'd1;
    wire [3:0] next_thousands = thousands_en ? (thousands == 4'd9 ? 4'd0 : thousands + 4'd1) : thousands;

    // Sequential update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            if (ones_en)
                ones <= next_ones;
            if (tens_en)
                tens <= next_tens;
            if (hundreds_en)
                hundreds <= next_hundreds;
            if (thousands_en)
                thousands <= next_thousands;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals combinationally indicate when a digit rolls over (== 9),
    // which triggers increment of the next higher digit.
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Combinational calculation of next values and carries for digits
    wire carry_ones  = (ones == 4'd9);
    wire carry_tens  = carry_ones && (tens == 4'd9);
    wire carry_hund  = carry_tens && (hundreds == 4'd9);

    wire [3:0] ones_next  = carry_ones  ? 4'd0 : (ones + 4'd1);
    wire [3:0] tens_next  = carry_tens  ? 4'd0 : (carry_ones  ? (tens + 4'd1) : tens);
    wire [3:0] hund_next  = carry_hund  ? 4'd0 : (carry_tens  ? (hundreds + 4'd1) : hundreds);
    wire [3:0] thou_next  = carry_hund  ? ((thousands == 4'd9) ? 4'd0 : (thousands + 4'd1)) : thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Update only digits that change, minimizing toggling and improving power
            ones      <= ones_next;
            tens      <= (carry_ones) ? tens_next : tens;
            hundreds  <= (carry_tens) ? hund_next : hundreds;
            thousands <= (carry_hund) ? thou_next : thousands;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
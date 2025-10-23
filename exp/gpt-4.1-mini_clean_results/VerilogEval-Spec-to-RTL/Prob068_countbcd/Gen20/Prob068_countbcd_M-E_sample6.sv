module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire carry_ones, carry_tens, carry_hundreds;

    // Increment ones digit
    wire [3:0] ones_next = (ones == 4'd9) ? 4'd0 : ones + 4'd1;
    assign carry_ones = (ones == 4'd9);

    // Increment tens digit on carry from ones
    wire [3:0] tens_next = carry_ones ? ((tens == 4'd9) ? 4'd0 : tens + 4'd1) : tens;
    assign carry_tens = carry_ones && (tens == 4'd9);

    // Increment hundreds digit on carry from tens
    wire [3:0] hundreds_next = carry_tens ? ((hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1) : hundreds;
    assign carry_hundreds = carry_tens && (hundreds == 4'd9);

    // Increment thousands digit on carry from hundreds
    wire [3:0] thousands_next = carry_hundreds ? ((thousands == 4'd9) ? 4'd0 : thousands + 4'd1) : thousands;

    // Enable signals indicate when upper digits should increment (on carry-in)
    assign ena[0] = carry_ones;       // enable tens
    assign ena[1] = carry_tens;       // enable hundreds
    assign ena[2] = carry_hundreds;   // enable thousands

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

    assign q = {thousands, hundreds, tens, ones};

endmodule
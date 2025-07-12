module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    wire carry0, carry1, carry2;

    // Determine carry out from each digit increment
    // carry0: ones rolls over from 9 to 0, carry to tens
    assign carry0 = (ones == 4'd9);
    // carry1: tens rolls over from 9 to 0, carry to hundreds
    assign carry1 = carry0 && (tens == 4'd9);
    // carry2: hundreds rolls over from 9 to 0, carry to thousands
    assign carry2 = carry1 && (hundreds == 4'd9);

    // Enable signals for upper digits
    assign ena[0] = carry0;  // enable tens increment
    assign ena[1] = carry1;  // enable hundreds increment
    assign ena[2] = carry2;  // enable thousands increment

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Update ones digit
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;

            // Update tens digit
            if (carry0) begin
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            end

            // Update hundreds digit
            if (carry1) begin
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            end

            // Update thousands digit
            if (carry2) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
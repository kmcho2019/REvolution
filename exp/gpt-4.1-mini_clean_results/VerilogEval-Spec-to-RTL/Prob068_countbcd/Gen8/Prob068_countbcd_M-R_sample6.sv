module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg       carry_ones, carry_tens, carry_hundreds;

    // Compute enables based on carry signals
    // Each enable signals when the lower digit has just reached 9 and will roll over
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = carry_ones && (tens == 4'd9);
    assign ena[2] = carry_tens && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            carry_ones    <= 1'b0;
            carry_tens    <= 1'b0;
            carry_hundreds<= 1'b0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                carry_ones <= 1'b1;
            end else begin
                ones <= ones + 4'd1;
                carry_ones <= 1'b0;
            end

            // Increment tens digit if carry from ones
            if (carry_ones) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    carry_tens <= 1'b1;
                end else begin
                    tens <= tens + 4'd1;
                    carry_tens <= 1'b0;
                end
            end else begin
                carry_tens <= 1'b0;
            end

            // Increment hundreds digit if carry from tens
            if (carry_tens) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    carry_hundreds <= 1'b1;
                end else begin
                    hundreds <= hundreds + 4'd1;
                    carry_hundreds <= 1'b0;
                end
            end else begin
                carry_hundreds <= 1'b0;
            end

            // Increment thousands digit if carry from hundreds
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
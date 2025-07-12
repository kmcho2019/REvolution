module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals: assert when the lower digit is 9 to indicate the next digit increments
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands<= 4'd0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                // Increment tens digit
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    // Increment hundreds digit
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        // Increment thousands digit with rollover at 9
                        if (thousands == 4'd9)
                            thousands <= 4'd0;
                        else
                            thousands <= thousands + 4'd1;
                    end else
                        hundreds <= hundreds + 4'd1;
                end else
                    tens <= tens + 4'd1;
            end else begin
                ones <= ones + 4'd1;
            end
        end
    end

    // Pack the digits into q output
    assign q = {thousands, hundreds, tens, ones};

endmodule
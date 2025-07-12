module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals indicate when the next digit should increment
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit
            if (ones != 4'd9) begin
                ones <= ones + 4'd1;
            end else begin
                ones <= 4'd0;
                // Increment tens digit
                if (tens != 4'd9) begin
                    tens <= tens + 4'd1;
                end else begin
                    tens <= 4'd0;
                    // Increment hundreds digit
                    if (hundreds != 4'd9) begin
                        hundreds <= hundreds + 4'd1;
                    end else begin
                        hundreds <= 4'd0;
                        // Increment thousands digit
                        if (thousands != 4'd9) begin
                            thousands <= thousands + 4'd1;
                        end else begin
                            thousands <= 4'd0;
                        end
                    end
                end
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Generate enable signals indicating when the next digit should increment
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit with rollover
            if (ones == 4'd9) begin
                ones <= 4'd0;

                // Increment tens digit with rollover
                if (tens == 4'd9) begin
                    tens <= 4'd0;

                    // Increment hundreds digit with rollover
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;

                        // Increment thousands digit with rollover
                        if (thousands == 4'd9) begin
                            thousands <= 4'd0;
                        end else begin
                            thousands <= thousands + 1'b1;
                        end
                    end else begin
                        hundreds <= hundreds + 1'b1;
                    end
                end else begin
                    tens <= tens + 1'b1;
                end
            end else begin
                ones <= ones + 1'b1;
            end
        end
    end

    // Concatenate digits into output bus
    assign q = {thousands, hundreds, tens, ones};

endmodule
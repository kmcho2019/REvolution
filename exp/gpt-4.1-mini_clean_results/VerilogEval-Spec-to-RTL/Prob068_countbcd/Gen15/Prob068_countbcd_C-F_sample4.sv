module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals indicating when upper digits should increment
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
            // Increment ones digit and determine carry
            if (ones == 4'd9) begin
                ones <= 4'd0;

                // Increment tens digit with carry
                if (tens == 4'd9) begin
                    tens <= 4'd0;

                    // Increment hundreds digit with carry
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;

                        // Increment thousands digit with carry (max digit = 9)
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

    // Concatenate outputs
    assign q = {thousands, hundreds, tens, ones};

endmodule
module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    wire ones_rollover    = (ones == 4'd9);
    wire tens_rollover    = (tens == 4'd9);
    wire hundreds_rollover= (hundreds == 4'd9);

    // Enable signals indicate when next digit should increment
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ena[1] & hundreds_rollover;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit and generate carry if needed
            if (ones == 4'd9) begin
                ones <= 4'd0;
                // Increment tens digit and generate carry
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    // Increment hundreds digit and generate carry
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        // Increment thousands digit with wrap-around at 9
                        if (thousands == 4'd9) begin
                            thousands <= 4'd0;
                        end else begin
                            thousands <= thousands + 4'd1;
                        end
                    end else begin
                        hundreds <= hundreds + 4'd1;
                    end
                end else begin
                    tens <= tens + 4'd1;
                end
            end else begin
                ones <= ones + 4'd1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
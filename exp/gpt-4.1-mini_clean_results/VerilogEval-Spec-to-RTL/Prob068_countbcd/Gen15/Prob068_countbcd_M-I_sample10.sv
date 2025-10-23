module TopModule (
    input         clk,
    input         reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] digit [3:0]; // digit[0] = ones, digit[1] = tens, digit[2] = hundreds, digit[3] = thousands

    wire carry_ones_to_tens = (digit[0] == 4'd9);
    wire carry_tens_to_hundreds = carry_ones_to_tens && (digit[1] == 4'd9);
    wire carry_hundreds_to_thousands = carry_tens_to_hundreds && (digit[2] == 4'd9);

    // Update ena registers synchronously to reduce glitches
    always @(posedge clk) begin
        if (reset) begin
            ena <= 3'b000;
        end else begin
            ena[0] <= carry_ones_to_tens;
            ena[1] <= carry_tens_to_hundreds;
            ena[2] <= carry_hundreds_to_thousands;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            digit[0] <= 4'd0;
            digit[1] <= 4'd0;
            digit[2] <= 4'd0;
            digit[3] <= 4'd0;
            q <= 16'd0;
        end else begin
            // Increment ones digit
            if (digit[0] == 4'd9) begin
                digit[0] <= 4'd0;
                // Increment tens digit
                if (digit[1] == 4'd9) begin
                    digit[1] <= 4'd0;
                    // Increment hundreds digit
                    if (digit[2] == 4'd9) begin
                        digit[2] <= 4'd0;
                        // Increment thousands digit with rollover at 9->0
                        if (digit[3] == 4'd9) begin
                            digit[3] <= 4'd0;
                        end else begin
                            digit[3] <= digit[3] + 4'd1;
                        end
                    end else begin
                        digit[2] <= digit[2] + 4'd1;
                    end
                end else begin
                    digit[1] <= digit[1] + 4'd1;
                end
            end else begin
                digit[0] <= digit[0] + 4'd1;
            end
            // Update output vector q
            q <= {digit[3], digit[2], digit[1], digit[0]};
        end
    end

endmodule
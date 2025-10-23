module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands

    // Carry signals between digits
    wire c0, c1, c2;

    // Calculate carry signals: carry when digit == 9 and increment carry in
    assign c0 = (digits[0] == 4'd9);
    assign c1 = c0 & (digits[1] == 4'd9);
    assign c2 = c1 & (digits[2] == 4'd9);

    // Enable signals for digits 1 to 3 when their lower digit(s) rolled over 9
    assign ena = {c2, c1, c0};

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            // Ones digit increments every cycle, rolls over at 9
            if (digits[0] == 4'd9)
                digits[0] <= 4'd0;
            else
                digits[0] <= digits[0] + 4'd1;

            // Tens digit increments if ones digit rolls over
            if (c0) begin
                if (digits[1] == 4'd9)
                    digits[1] <= 4'd0;
                else
                    digits[1] <= digits[1] + 4'd1;
            end

            // Hundreds digit increments if tens digit rolls over
            if (c1) begin
                if (digits[2] == 4'd9)
                    digits[2] <= 4'd0;
                else
                    digits[2] <= digits[2] + 4'd1;
            end

            // Thousands digit increments if hundreds digit rolls over
            if (c2) begin
                if (digits[3] == 4'd9)
                    digits[3] <= 4'd0;
                else
                    digits[3] <= digits[3] + 4'd1;
            end
        end
    end

    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule
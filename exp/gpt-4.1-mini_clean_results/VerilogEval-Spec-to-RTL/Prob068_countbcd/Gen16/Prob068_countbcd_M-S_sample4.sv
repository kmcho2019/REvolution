module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, etc.

    wire c1, c2, c3; // carry signals between digits

    // Carry out if digit is 9 and needs to roll over on increment
    assign ena[0] = (digits[0] == 4'd9);
    assign ena[1] = (digits[1] == 4'd9) && ena[0];
    assign ena[2] = (digits[2] == 4'd9) && ena[1];

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            // Increment ones digit and ripple carry if needed
            if (digits[0] == 4'd9) begin
                digits[0] <= 4'd0;
                if (digits[1] == 4'd9) begin
                    digits[1] <= 4'd0;
                    if (digits[2] == 4'd9) begin
                        digits[2] <= 4'd0;
                        if (digits[3] == 4'd9) begin
                            digits[3] <= 4'd0; // roll over all digits
                        end else begin
                            digits[3] <= digits[3] + 1;
                        end
                    end else begin
                        digits[2] <= digits[2] + 1;
                    end
                end else begin
                    digits[1] <= digits[1] + 1;
                end
            end else begin
                digits[0] <= digits[0] + 1;
            end
        end
    end

    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule
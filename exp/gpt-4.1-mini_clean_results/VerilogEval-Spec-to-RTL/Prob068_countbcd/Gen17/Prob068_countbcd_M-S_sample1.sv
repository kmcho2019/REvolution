module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands

    // Enable signals indicate when each upper digit should be incremented
    assign ena[0] = (digits[0] == 4'd9);
    assign ena[1] = ena[0] & (digits[1] == 4'd9);
    assign ena[2] = ena[1] & (digits[2] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            if (digits[0] == 4'd9) begin
                digits[0] <= 4'd0;
                if (digits[1] == 4'd9) begin
                    digits[1] <= 4'd0;
                    if (digits[2] == 4'd9) begin
                        digits[2] <= 4'd0;
                        digits[3] <= (digits[3] == 4'd9) ? 4'd0 : digits[3] + 1;
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
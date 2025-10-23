module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands

    // Enable signals: indicate when lower digit is 9 so the next digit increments
    assign ena[0] = (digits[0] == 4'd9);
    assign ena[1] = (digits[1] == 4'd9) & ena[0];
    assign ena[2] = (digits[2] == 4'd9) & ena[1];

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            // Increment ones digit and propagate carry
            if (digits[0] == 4'd9) begin
                digits[0] <= 4'd0;
                if (digits[1] == 4'd9) begin
                    digits[1] <= 4'd0;
                    if (digits[2] == 4'd9) begin
                        digits[2] <= 4'd0;
                        if (digits[3] == 4'd9)
                            digits[3] <= 4'd0;
                        else
                            digits[3] <= digits[3] + 4'd1;
                    end else
                        digits[2] <= digits[2] + 4'd1;
                end else
                    digits[1] <= digits[1] + 4'd1;
            end else begin
                digits[0] <= digits[0] + 4'd1;
            end
        end
    end

    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule
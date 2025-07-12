module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] digit_0, digit_1, digit_2, digit_3;

always @(posedge clk) begin
    if (reset) begin
        digit_0 <= 4'd0;
        digit_1 <= 4'd0;
        digit_2 <= 4'd0;
        digit_3 <= 4'd0;
    end else begin
        // Increment the least significant digit
        if (digit_0 == 4'd9) begin
            digit_0 <= 4'd0;
            ena[0] <= 1'b1;
        end else begin
            digit_0 <= digit_0 + 1;
            ena[0] <= 1'b0;
        end

        // Increment the tens digit
        if (ena[0] && digit_1 == 4'd9) begin
            digit_1 <= 4'd0;
            ena[1] <= 1'b1;
        end else if (ena[0]) begin
            digit_1 <= digit_1 + 1;
            ena[1] <= 1'b0;
        end else begin
            ena[1] <= 1'b0;
        end

        // Increment the hundreds digit
        if (ena[1] && digit_2 == 4'd9) begin
            digit_2 <= 4'd0;
            ena[2] <= 1'b1;
        end else if (ena[1]) begin
            digit_2 <= digit_2 + 1;
            ena[2] <= 1'b0;
        end else begin
            ena[2] <= 1'b0;
        end

        // Increment the thousands digit
        if (ena[2] && digit_3 == 4'd9) begin
            digit_3 <= 4'd0;
        end else if (ena[2]) begin
            digit_3 <= digit_3 + 1;
        end
    end
end

assign q = {digit_3, digit_2, digit_1, digit_0};

endmodule
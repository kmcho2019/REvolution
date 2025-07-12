module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] digits;

    // Extract individual digits for convenience
    wire [3:0] ones      = digits[3:0];
    wire [3:0] tens      = digits[7:4];
    wire [3:0] hundreds  = digits[11:8];
    wire [3:0] thousands = digits[15:12];

    // Enable signals for incrementing upper digits
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            digits <= 16'd0;
        end else begin
            if (ones < 4'd9)
                digits[3:0] <= ones + 4'd1;
            else begin
                digits[3:0] <= 4'd0;
                if (tens < 4'd9) begin
                    digits[7:4] <= tens + 4'd1;
                    digits[11:4] <= digits[11:4]; // hundreds and thousands unchanged
                end else begin
                    digits[7:4] <= 4'd0;
                    if (hundreds < 4'd9) begin
                        digits[11:8] <= hundreds + 4'd1;
                        digits[15:12] <= digits[15:12]; // thousands unchanged
                    end else begin
                        digits[11:8] <= 4'd0;
                        if (thousands < 4'd9)
                            digits[15:12] <= thousands + 4'd1;
                        else
                            digits[15:12] <= 4'd0;
                    end
                end
            end
        end
    end

    assign q = digits;

endmodule
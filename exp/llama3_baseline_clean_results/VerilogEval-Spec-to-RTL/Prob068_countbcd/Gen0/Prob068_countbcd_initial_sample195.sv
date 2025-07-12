module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones_digit;
reg [3:0] tens_digit;
reg [3:0] hundreds_digit;
reg [3:0] thousands_digit;

always @(posedge clk) begin
    if (reset) begin
        ones_digit <= 0;
        tens_digit <= 0;
        hundreds_digit <= 0;
        thousands_digit <= 0;
    end else begin
        if (ones_digit == 9) begin
            ones_digit <= 0;
            if (tens_digit == 9) begin
                tens_digit <= 0;
                if (hundreds_digit == 9) begin
                    hundreds_digit <= 0;
                    if (thousands_digit == 9) begin
                        thousands_digit <= 0;
                    end else begin
                        thousands_digit <= thousands_digit + 1;
                    end
                end else begin
                    hundreds_digit <= hundreds_digit + 1;
                end
            end else begin
                tens_digit <= tens_digit + 1;
            end
        end else begin
            ones_digit <= ones_digit + 1;
        end
    end
end

assign ena[0] = (ones_digit == 9) ? 1'b1 : 1'b0;
assign ena[1] = (tens_digit == 9 && ones_digit == 0) ? 1'b1 : 1'b0;
assign ena[2] = (hundreds_digit == 9 && tens_digit == 0 && ones_digit == 0) ? 1'b1 : 1'b0;

assign q[3:0] = ones_digit;
assign q[7:4] = tens_digit;
assign q[11:8] = hundreds_digit;
assign q[15:12] = thousands_digit;

endmodule
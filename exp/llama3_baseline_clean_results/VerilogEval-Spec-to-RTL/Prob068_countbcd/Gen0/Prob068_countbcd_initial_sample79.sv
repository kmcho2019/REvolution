module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones;
reg [3:0] q_tens;
reg [3:0] q_hundreds;
reg [3:0] q_thousands;

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
    end else begin
        // Increment ones digit
        if (q_ones == 9) begin
            q_ones <= 0;
        end else begin
            q_ones <= q_ones + 1;
        end

        // Increment tens digit
        if (q_ones == 0 && q_tens != 9) begin
            q_tens <= q_tens + 1;
        end else if (q_ones == 0 && q_tens == 9) begin
            q_tens <= 0;
        end

        // Increment hundreds digit
        if (q_tens == 0 && q_ones == 0 && q_hundreds != 9) begin
            q_hundreds <= q_hundreds + 1;
        end else if (q_tens == 0 && q_ones == 0 && q_hundreds == 9) begin
            q_hundreds <= 0;
        end

        // Increment thousands digit
        if (q_hundreds == 0 && q_tens == 0 && q_ones == 0 && q_thousands != 9) begin
            q_thousands <= q_thousands + 1;
        end else if (q_hundreds == 0 && q_tens == 0 && q_ones == 0 && q_thousands == 9) begin
            q_thousands <= 0;
        end
    end
end

// Assign output signals
assign q[3:0] = q_ones;
assign q[7:4] = q_tens;
assign q[11:8] = q_hundreds;
assign q[15:12] = q_thousands;

// Generate enable signals
assign ena[0] = (q_ones == 0 && q_tens != 9) || (q_ones == 0 && q_tens == 9);
assign ena[1] = (q_tens == 0 && q_ones == 0 && q_hundreds != 9) || (q_tens == 0 && q_ones == 0 && q_hundreds == 9);
assign ena[2] = (q_hundreds == 0 && q_tens == 0 && q_ones == 0 && q_thousands != 9) || (q_hundreds == 0 && q_tens == 0 && q_ones == 0 && q_thousands == 9);

endmodule
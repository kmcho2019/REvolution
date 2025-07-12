module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

always @(posedge clk) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
        ena <= 0;
    end else begin
        // Increment ones digit
        if (ones == 9) begin
            ones <= 0;
            // Enable tens digit
            ena[0] <= 1;
        end else begin
            ones <= ones + 1;
            ena[0] <= 0;
        end

        // Increment tens digit
        if (tens == 9 && ena[0]) begin
            tens <= 0;
            // Enable hundreds digit
            ena[1] <= 1;
        end else if (ena[0]) begin
            tens <= tens + 1;
            ena[1] <= 0;
        end else begin
            ena[1] <= 0;
        end

        // Increment hundreds digit
        if (hundreds == 9 && ena[1]) begin
            hundreds <= 0;
            // Enable thousands digit
            ena[2] <= 1;
        end else if (ena[1]) begin
            hundreds <= hundreds + 1;
            ena[2] <= 0;
        end else begin
            ena[2] <= 0;
        end

        // Increment thousands digit
        if (thousands == 9 && ena[2]) begin
            thousands <= 0;
        end else if (ena[2]) begin
            thousands <= thousands + 1;
        end

        q <= {thousands, hundreds, tens, ones};
    end
end

endmodule
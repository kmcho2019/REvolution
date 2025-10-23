module TopModule (
    input         clk,
    input         reset,
    output reg [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Internal carry signals for incrementing each digit
    wire carry_ones;
    wire carry_tens;
    wire carry_hundreds;

    assign carry_ones = (ones == 4'd9);
    assign carry_tens = carry_ones && (tens == 4'd9);
    assign carry_hundreds = carry_tens && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b0;
        end else begin
            // Increment ones digit, and generate carry signals
            if (carry_ones) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 1;
            end

            // Increment tens digit if ones digit overflowed
            if (carry_ones) begin
                if (carry_tens) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 1;
                end
            end

            // Increment hundreds digit if tens digit overflowed
            if (carry_tens) begin
                if (carry_hundreds) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 1;
                end
            end

            // Increment thousands digit if hundreds digit overflowed
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 1;
                end
            end

            // Register enable signals
            ena[0] <= carry_ones;
            ena[1] <= carry_tens;
            ena[2] <= carry_hundreds;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
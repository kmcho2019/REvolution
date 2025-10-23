module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Combinational carry signals based on current count
    wire carry_ones = (ones == 4'd9);
    wire carry_tens = carry_ones && (tens == 4'd9);
    wire carry_hundreds = carry_tens && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b000;
            q         <= 16'd0;
        end else begin
            // Update ones digit
            if (carry_ones)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Update tens digit
            if (carry_ones) begin
                if (carry_tens)
                    tens <= 4'd0;
                else
                    tens <= tens + 1'b1;
            end

            // Update hundreds digit
            if (carry_tens) begin
                if (carry_hundreds)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end

            // Update thousands digit
            if (carry_hundreds) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end

            // Set enable signals synchronously reflecting increments
            ena[0] <= carry_ones;      // enable tens
            ena[1] <= carry_tens;      // enable hundreds
            ena[2] <= carry_hundreds;  // enable thousands

            // Update output q with updated digit values
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule
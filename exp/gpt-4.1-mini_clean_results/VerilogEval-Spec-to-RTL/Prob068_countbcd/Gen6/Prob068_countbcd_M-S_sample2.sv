module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b0;
            q         <= 16'd0;
        end else begin
            // Increment ones digit and detect carry
            reg carry_ones;
            reg carry_tens;
            reg carry_hundreds;

            if (ones == 4'd9) begin
                ones <= 4'd0;
                carry_ones = 1'b1;
            end else begin
                ones <= ones + 1'b1;
                carry_ones = 1'b0;
            end

            // Increment tens if carry from ones
            if (carry_ones) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    carry_tens = 1'b1;
                end else begin
                    tens <= tens + 1'b1;
                    carry_tens = 1'b0;
                end
            end else begin
                tens <= tens;
                carry_tens = 1'b0;
            end

            // Increment hundreds if carry from tens
            if (carry_tens) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    carry_hundreds = 1'b1;
                end else begin
                    hundreds <= hundreds + 1'b1;
                    carry_hundreds = 1'b0;
                end
            end else begin
                hundreds <= hundreds;
                carry_hundreds = 1'b0;
            end

            // Increment thousands if carry from hundreds
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 1'b1;
                end
            end else begin
                thousands <= thousands;
            end

            // Generate enable signals for tens, hundreds, thousands increments
            ena[0] <= carry_ones;
            ena[1] <= carry_tens;
            ena[2] <= carry_hundreds;

            // Assemble the output
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule
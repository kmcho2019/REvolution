module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal digit registers for clarity
    reg [3:0] ones, tens, hundreds, thousands;
    reg ena_tens, ena_hundreds, ena_thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_tens <= 1'b0;
            ena_hundreds <= 1'b0;
            ena_thousands <= 1'b0;
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Determine if current digits are at max BCD value
            // to create carry conditions for the next digit increment
            // These will define enables for upper digits in this cycle
            ena_tens <= (ones == 4'd9);
            ena_hundreds <= ena_tens && (tens == 4'd9);
            ena_thousands <= ena_hundreds && (hundreds == 4'd9);

            // Update ones digit: increment and roll over at 9
            if (ones == 4'd9)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Update tens digit if enabled (carry from ones)
            if (ena_tens) begin
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 1'b1;
            end

            // Update hundreds digit if enabled (carry from tens)
            if (ena_hundreds) begin
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end

            // Update thousands digit if enabled (carry from hundreds)
            if (ena_thousands) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end

            // Concatenate digit registers into output bus
            q <= {thousands, hundreds, tens, ones};

            // Drive enable outputs reflecting increments in this cycle
            ena <= {ena_thousands, ena_hundreds, ena_tens};
        end
    end

endmodule
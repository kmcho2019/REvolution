module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Registers for each BCD digit
    reg [3:0] ones, tens, hundreds, thousands;

    // Next state variables
    reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;

    // Flags indicating if digit increments this cycle (enable signals)
    reg ena_ones, ena_tens, ena_hundreds, ena_thousands;

    always @* begin
        // Default next state is current state
        next_ones = ones;
        next_tens = tens;
        next_hundreds = hundreds;
        next_thousands = thousands;

        // By default no enable
        ena_ones = 1'b0;
        ena_tens = 1'b0;
        ena_hundreds = 1'b0;
        ena_thousands = 1'b0;

        // Increment ones digit every clock cycle
        if (ones == 4'd9) begin
            next_ones = 4'd0;
            ena_ones = 1'b1; // ones digit rollover triggers tens increment

            // Increment tens digit
            if (tens == 4'd9) begin
                next_tens = 4'd0;
                ena_tens = 1'b1; // tens rollover triggers hundreds increment

                // Increment hundreds digit
                if (hundreds == 4'd9) begin
                    next_hundreds = 4'd0;
                    ena_hundreds = 1'b1; // hundreds rollover triggers thousands increment

                    // Increment thousands digit
                    if (thousands == 4'd9) begin
                        next_thousands = 4'd0;
                        ena_thousands = 1'b1; // though ena_thousands unused in output
                    end else begin
                        next_thousands = thousands + 1;
                    end
                end else begin
                    next_hundreds = hundreds + 1;
                end
            end else begin
                next_tens = tens + 1;
            end
        end else begin
            next_ones = ones + 1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena <= 3'b000;
            q <= 16'd0;
        end else begin
            ones <= next_ones;
            tens <= next_tens;
            hundreds <= next_hundreds;
            thousands <= next_thousands;

            // ena[0] for tens increment enable
            // ena[1] for hundreds increment enable
            // ena[2] for thousands increment enable
            ena <= {ena_hundreds, ena_tens, ena_ones};

            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule
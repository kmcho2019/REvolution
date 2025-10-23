module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,      // ena[0]: tens enable, ena[1]: hundreds enable, ena[2]: thousands enable
    output reg [15:0] q        // q[3:0]: ones, q[7:4]: tens, q[11:8]: hundreds, q[15:12]: thousands
);

    // Registers for each BCD digit
    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals delayed by one cycle to control increments of upper digits
    reg ena_ones_to_tens;       // enable to increment tens digit (from ones rollover)
    reg ena_tens_to_hundreds;   // enable to increment hundreds digit (from tens rollover)
    reg ena_hundreds_to_thousands; // enable to increment thousands digit (from hundreds rollover)

    // Intermediate wires to detect rollovers this cycle
    wire ones_rollover;
    wire tens_rollover;
    wire hundreds_rollover;

    // Detect rollovers: when digit increments past 9 (BCD max)
    assign ones_rollover     = (ones == 4'd9);
    assign tens_rollover     = (tens == 4'd9);
    assign hundreds_rollover = (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset all digits and enables
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;

            ena_ones_to_tens     <= 1'b0;
            ena_tens_to_hundreds <= 1'b0;
            ena_hundreds_to_thousands <= 1'b0;

            ena <= 3'b000;
            q <= 16'd0;
        end else begin
            // Update ena outputs from delayed enables of previous increments
            ena <= {ena_hundreds_to_thousands, ena_tens_to_hundreds, ena_ones_to_tens};

            // Increment ones digit every clock cycle
            if (ones_rollover) 
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            // Propagate enable signals for upper digits (delayed by 1 cycle)
            // These indicate when the corresponding digit was incremented in this clock cycle
            // Used as ena output and to increment upper digits in next cycle
            ena_ones_to_tens     <= ones_rollover;
            ena_tens_to_hundreds <= tens_rollover;
            ena_hundreds_to_thousands <= hundreds_rollover;

            // Increment tens digit only if enabled by ones rollover last cycle
            if (ena_ones_to_tens) begin
                if (tens_rollover)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Increment hundreds digit only if enabled by tens rollover last cycle
            if (ena_tens_to_hundreds) begin
                if (hundreds_rollover)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Increment thousands digit only if enabled by hundreds rollover last cycle
            if (ena_hundreds_to_thousands) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end

            // Combine digits to q output
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule
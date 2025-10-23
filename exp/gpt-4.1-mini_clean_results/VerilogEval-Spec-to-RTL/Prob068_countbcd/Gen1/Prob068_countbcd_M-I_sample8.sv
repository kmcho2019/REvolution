module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal digit registers
    reg [3:0] ones, tens, hundreds, thousands;

    // Internal wires for carry flags
    wire carry_ones, carry_tens, carry_hundreds;

    // Compute carry out of ones digit
    assign carry_ones = (ones == 4'd9);
    // Compute carry out of tens digit
    assign carry_tens = (tens == 4'd9);
    // Compute carry out of hundreds digit
    assign carry_hundreds = (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena <= 3'b000;
            q <= 16'd0;
        end else begin
            // Increment ones digit every clock
            if (carry_ones)
                ones <= 4'd0;
            else
                ones <= ones + 1;

            // Increment tens digit if ones digit rolled over
            if (carry_ones) begin
                if (carry_tens)
                    tens <= 4'd0;
                else
                    tens <= tens + 1;
            end

            // Increment hundreds digit if tens digit rolled over
            if (carry_ones && carry_tens) begin
                if (carry_hundreds)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1;
            end

            // Increment thousands digit if hundreds digit rolled over
            if (carry_ones && carry_tens && carry_hundreds) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1;
            end

            // Update enable outputs reflecting digit increments
            // ena[0]: tens increment enable (when ones rolled over)
            // ena[1]: hundreds increment enable (when tens rolled over)
            // ena[2]: thousands increment enable (when hundreds rolled over)
            ena[0] <= carry_ones;
            ena[1] <= carry_ones & carry_tens;
            ena[2] <= carry_ones & carry_tens & carry_hundreds;

            // Concatenate digits into q synchronously
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule
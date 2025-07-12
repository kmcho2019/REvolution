module TopModule (
    input         clk,
    input         reset,
    output reg [2:0]  ena,
    output [15:0] q
);

    // Separate registers for each digit
    reg [3:0] ones, tens, hundreds, thousands;

    // Internal carry signals to pipeline carry propagation over two cycles
    reg carry_ones_to_tens;      // carry from ones to tens
    reg carry_tens_to_hundreds;  // carry from tens to hundreds
    reg carry_hundreds_to_thousands; // carry from hundreds to thousands

    // Stage 1: increment ones and generate carry_ones_to_tens
    // Stage 2: on next clock increment upper digits if carry_in is asserted, generate next carries

    // Register ena signals to reduce glitches and provide stable enables
    always @(posedge clk) begin
        if (reset) begin
            ena <= 3'b000;
        end else begin
            // ena[0] indicates tens should increment (carry from ones)
            ena[0] <= carry_ones_to_tens;
            // ena[1] indicates hundreds should increment (carry from tens)
            ena[1] <= carry_tens_to_hundreds;
            // ena[2] indicates thousands should increment (carry from hundreds)
            ena[2] <= carry_hundreds_to_thousands;
        end
    end

    // Increment logic separated into two pipeline stages inside single always block
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;

            carry_ones_to_tens      <= 1'b0;
            carry_tens_to_hundreds  <= 1'b0;
            carry_hundreds_to_thousands <= 1'b0;
        end else begin
            // Stage 1: Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                carry_ones_to_tens <= 1'b1;
            end else begin
                ones <= ones + 1'b1;
                carry_ones_to_tens <= 1'b0;
            end

            // Stage 2: Use carry_ones_to_tens from previous clock to increment tens
            if (carry_ones_to_tens) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    carry_tens_to_hundreds <= 1'b1;
                end else begin
                    tens <= tens + 1'b1;
                    carry_tens_to_hundreds <= 1'b0;
                end
            end else begin
                // If no carry_in, tens unchanged, carry out zero
                carry_tens_to_hundreds <= 1'b0;
            end

            // Similarly, use carry_tens_to_hundreds to increment hundreds
            if (carry_tens_to_hundreds) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    carry_hundreds_to_thousands <= 1'b1;
                end else begin
                    hundreds <= hundreds + 1'b1;
                    carry_hundreds_to_thousands <= 1'b0;
                end
            end else begin
                carry_hundreds_to_thousands <= 1'b0;
            end

            // Finally, increment thousands if carry_hundreds_to_thousands asserted
            if (carry_hundreds_to_thousands) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0; // roll over thousands digit as well
                end else begin
                    thousands <= thousands + 1'b1;
                end
            end
        end
    end

    // Output concatenation
    assign q = {thousands, hundreds, tens, ones};

endmodule
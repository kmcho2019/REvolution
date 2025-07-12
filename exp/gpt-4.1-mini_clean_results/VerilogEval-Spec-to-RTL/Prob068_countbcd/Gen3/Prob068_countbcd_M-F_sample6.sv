module TopModule (
    input clk,
    input reset,
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
            ena       <= 3'b000;
            q         <= 16'd0;
        end else begin
            // Declare combinational next-state and carry variables
            reg carry_ones, carry_tens, carry_hundreds;
            reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;
            reg [2:0] next_ena;

            // Increment ones digit
            if (ones == 4'd9) begin
                next_ones = 4'd0;
                carry_ones = 1'b1;
            end else begin
                next_ones = ones + 1'b1;
                carry_ones = 1'b0;
            end

            // Increment tens digit if ones carry
            if (carry_ones) begin
                if (tens == 4'd9) begin
                    next_tens = 4'd0;
                    carry_tens = 1'b1;
                end else begin
                    next_tens = tens + 1'b1;
                    carry_tens = 1'b0;
                end
            end else begin
                next_tens = tens;
                carry_tens = 1'b0;
            end

            // Increment hundreds digit if tens carry
            if (carry_tens) begin
                if (hundreds == 4'd9) begin
                    next_hundreds = 4'd0;
                    carry_hundreds = 1'b1;
                end else begin
                    next_hundreds = hundreds + 1'b1;
                    carry_hundreds = 1'b0;
                end
            end else begin
                next_hundreds = hundreds;
                carry_hundreds = 1'b0;
            end

            // Increment thousands digit if hundreds carry
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    next_thousands = 4'd0;
                end else begin
                    next_thousands = thousands + 1'b1;
                end
            end else begin
                next_thousands = thousands;
            end

            // Assign enables based on carries that cause upper digit increments this cycle
            next_ena[0] = carry_ones;      // enable tens digit
            next_ena[1] = carry_tens;      // enable hundreds digit
            next_ena[2] = carry_hundreds;  // enable thousands digit

            // Update all registers and outputs at once
            ones      <= next_ones;
            tens      <= next_tens;
            hundreds  <= next_hundreds;
            thousands <= next_thousands;
            ena       <= next_ena;
            q         <= {thousands, hundreds, tens, ones};
        end
    end

endmodule
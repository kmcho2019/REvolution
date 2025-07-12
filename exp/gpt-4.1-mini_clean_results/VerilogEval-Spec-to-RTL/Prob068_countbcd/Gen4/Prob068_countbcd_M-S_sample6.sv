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
            // Compute next ones digit and carry out
            wire ones_carry = (ones == 4'd9);
            wire [3:0] next_ones = ones_carry ? 4'd0 : ones + 1'b1;

            // Compute next tens digit and carry out
            wire tens_carry = ones_carry && (tens == 4'd9);
            wire [3:0] next_tens = ones_carry ? (tens_carry ? 4'd0 : tens + 1'b1) : tens;

            // Compute next hundreds digit and carry out
            wire hundreds_carry = tens_carry && (hundreds == 4'd9);
            wire [3:0] next_hundreds = tens_carry ? (hundreds_carry ? 4'd0 : hundreds + 1'b1) : hundreds;

            // Compute next thousands digit
            wire [3:0] next_thousands = hundreds_carry ? (thousands == 4'd9 ? 4'd0 : thousands + 1'b1) : thousands;

            // Update digits
            ones      <= next_ones;
            tens      <= next_tens;
            hundreds  <= next_hundreds;
            thousands <= next_thousands;

            // Assign enables indicating digit increments for upper digits
            ena[0] <= ones_carry;       // enable tens digit increment
            ena[1] <= tens_carry;       // enable hundreds digit increment
            ena[2] <= hundreds_carry;   // enable thousands digit increment

            // Update output vector q from updated digits
            q <= {next_thousands, next_hundreds, next_tens, next_ones};
        end
    end

endmodule
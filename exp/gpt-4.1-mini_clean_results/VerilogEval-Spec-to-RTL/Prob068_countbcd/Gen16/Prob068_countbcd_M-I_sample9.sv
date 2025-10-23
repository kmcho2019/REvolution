module TopModule (
    input         clk,
    input         reset,
    output reg [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg       carry_ones, carry_tens, carry_hundreds;

    // Combinational carry calculations before sequential update
    wire ones_carry = (ones == 4'd9);
    wire tens_carry = (tens == 4'd9);
    wire hundreds_carry = (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b000;
            carry_ones    <= 1'b0;
            carry_tens    <= 1'b0;
            carry_hundreds<= 1'b0;
        end else begin
            // Register carry signals from previous digits
            carry_ones     <= ones_carry;
            carry_tens     <= tens_carry & carry_ones;
            carry_hundreds <= hundreds_carry & carry_tens & carry_ones;

            // Update ena signals synchronously
            ena[0] <= carry_ones;                      // Increment tens if ones roll over
            ena[1] <= carry_tens & carry_ones;        // Increment hundreds if tens roll over
            ena[2] <= carry_hundreds & carry_tens & carry_ones; // Increment thousands if hundreds roll over

            // Increment digits based on carry signals from previous cycle
            if (carry_ones)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            if (carry_tens)
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;

            if (carry_hundreds)
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;

            if (carry_hundreds & carry_tens & carry_ones)
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule
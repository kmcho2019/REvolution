module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract current digits for combinational carry calculation
    wire [3:0] ones     = q[3:0];
    wire [3:0] tens     = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands= q[15:12];

    // Carry-out signals for each digit if incremented
    wire ones_carry     = (ones == 4'd9);
    wire tens_carry     = (tens == 4'd9);
    wire hundreds_carry = (hundreds == 4'd9);
    wire thousands_carry= (thousands == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Carry-in signals to each digit
            // Ones always increment, so ones increment always enabled
            // Tens increment if ones_carry (ones digit overflows)
            // Hundreds increment if tens_carry && tens incremented
            // Thousands increment if hundreds_carry && hundreds incremented

            // Determine which digits increment this cycle:
            // ones increments every cycle
            // tens increments if ones_carry
            // hundreds increments if tens_carry and tens incremented (which is same as tens increment)
            // thousands increments if hundreds_carry and hundreds incremented

            // Update ones digit
            if (ones_carry)
                q[3:0] <= 4'd0;
            else
                q[3:0] <= ones + 1'b1;

            // Update tens digit, enabled by ones_carry
            if (ones_carry) begin
                if (tens_carry)
                    q[7:4] <= 4'd0;
                else
                    q[7:4] <= tens + 1'b1;
            end

            // Update hundreds digit, enabled by tens_carry and ones_carry (because tens increment only if ones_carry)
            if (ones_carry && tens_carry) begin
                if (hundreds_carry)
                    q[11:8] <= 4'd0;
                else
                    q[11:8] <= hundreds + 1'b1;
            end

            // Update thousands digit, enabled by hundreds_carry, tens_carry and ones_carry (hundreds increment if tens and ones carry)
            if (ones_carry && tens_carry && hundreds_carry) begin
                if (thousands_carry)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= thousands + 1'b1;
            end

            // ena signals assert exactly when the digit increments (except ones digit, no enable output required)
            ena[0] <= ones_carry;                    // Tens enabled when ones carry
            ena[1] <= ones_carry && tens_carry;     // Hundreds enabled when tens carry and tens incremented
            ena[2] <= ones_carry && tens_carry && hundreds_carry; // Thousands enabled similarly
        end
    end

endmodule
module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg  [2:0]  ena,
    output reg  [15:0] q
);

    // Internal registers for each digit to hold enables for digits 1 to 3
    // ena[0] - enable tens increment
    // ena[1] - enable hundreds increment
    // ena[2] - enable thousands increment

    reg carry_ones, carry_tens, carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b0;
        end else begin
            // Break down q into digits
            reg [3:0] ones, tens, hundreds, thousands;
            reg [3:0] new_ones, new_tens, new_hundreds, new_thousands;

            ones      = q[3:0];
            tens      = q[7:4];
            hundreds  = q[11:8];
            thousands = q[15:12];

            // Increment ones digit
            if (ones == 4'd9) begin
                new_ones = 4'd0;
                carry_ones = 1'b1;
            end else begin
                new_ones = ones + 4'd1;
                carry_ones = 1'b0;
            end

            // Increment tens digit if carry from ones
            if (carry_ones) begin
                if (tens == 4'd9) begin
                    new_tens = 4'd0;
                    carry_tens = 1'b1;
                end else begin
                    new_tens = tens + 4'd1;
                    carry_tens = 1'b0;
                end
            end else begin
                new_tens = tens;
                carry_tens = 1'b0;
            end

            // Increment hundreds digit if carry from tens
            if (carry_tens) begin
                if (hundreds == 4'd9) begin
                    new_hundreds = 4'd0;
                    carry_hundreds = 1'b1;
                end else begin
                    new_hundreds = hundreds + 4'd1;
                    carry_hundreds = 1'b0;
                end
            end else begin
                new_hundreds = hundreds;
                carry_hundreds = 1'b0;
            end

            // Increment thousands digit if carry from hundreds
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    new_thousands = 4'd0;  // wrap-around after 9999
                end else begin
                    new_thousands = thousands + 4'd1;
                end
            end else begin
                new_thousands = thousands;
            end

            // Update q
            q <= {new_thousands, new_hundreds, new_tens, new_ones};

            // Update ena outputs to show when upper digits increment
            // These are registered to correspond with updates happening this cycle
            ena[0] <= carry_ones;     // tens increments if carry from ones
            ena[1] <= carry_tens;     // hundreds increments if carry from tens
            ena[2] <= carry_hundreds; // thousands increments if carry from hundreds
        end
    end

endmodule
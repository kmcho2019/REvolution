module TopModule(
    input         clk,       // clock
    input         reset,     // synchronous active-high reset
    output [2:0]  ena,       // enable signals for upper three digits
    output [15:0] q          // 16-bit BCD counter output
);

reg [15:0] count;           // 16-bit register to store the current count
reg [2:0]  enable;          // enable signals for upper three digits

always @(posedge clk) begin
    if (reset) begin        // synchronous reset
        count <= 0;
    end else begin
        // Calculate next count
        reg [3:0] ones, tens, hundreds, thousands;
        reg       carry;

        // Split the current count into individual digits
        {ones, tens, hundreds, thousands} = count;

        // Increment the ones digit
        ones <= ones + 1;

        // If the ones digit overflows, increment the tens digit and reset ones
        if (ones == 10) begin
            ones <= 0;
            tens <= tens + 1;
        end else begin
            tens <= tens;
        end

        // If the tens digit overflows, increment the hundreds digit and reset tens
        if (tens == 10) begin
            tens <= 0;
            hundreds <= hundreds + 1;
        end else begin
            hundreds <= hundreds;
        end

        // If the hundreds digit overflows, increment the thousands digit and reset hundreds
        if (hundreds == 10) begin
            hundreds <= 0;
            thousands <= thousands + 1;
        end else begin
            thousands <= thousands;
        end

        // Combine the digits back into the count
        count <= {thousands, hundreds, tens, ones};

        // Set the enable signals
        ena[0] <= (tens == 9 && ones == 9);  // hundreds enable
        ena[1] <= (hundreds == 9 && tens == 9 && ones == 9);  // thousands enable
        ena[2] <= 0;  // no higher digits to enable
    end
end

// Assign the count to the output
assign q = count;

endmodule
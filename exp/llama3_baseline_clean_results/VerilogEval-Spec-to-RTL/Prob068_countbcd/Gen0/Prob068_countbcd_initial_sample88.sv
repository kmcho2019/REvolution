module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

// Define the internal signals for the 4-bit counters
reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

// Define the internal signals for the enable flags
reg ena_ones_to_tens;
reg ena_tens_to_hundreds;
reg ena_hundreds_to_thousands;

// Synchronous reset and counter logic
always @ (posedge clk) begin
    if (reset) begin
        // Reset all counters and enable flags
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
        ena_ones_to_tens <= 0;
        ena_tens_to_hundreds <= 0;
        ena_hundreds_to_thousands <= 0;
    end else begin
        // Increment the ones digit
        ones <= ones + 1;
        
        // Check for overflow in the ones digit
        if (ones == 10) begin
            ones <= 0;
            ena_ones_to_tens <= 1;
        end else begin
            ena_ones_to_tens <= 0;
        end
        
        // Increment the tens digit when the ones digit overflows
        if (ena_ones_to_tens) begin
            tens <= tens + 1;
        end
        
        // Check for overflow in the tens digit
        if (tens == 10) begin
            tens <= 0;
            ena_tens_to_hundreds <= 1;
        end else begin
            ena_tens_to_hundreds <= 0;
        end
        
        // Increment the hundreds digit when the tens digit overflows
        if (ena_tens_to_hundreds) begin
            hundreds <= hundreds + 1;
        end
        
        // Check for overflow in the hundreds digit
        if (hundreds == 10) begin
            hundreds <= 0;
            ena_hundreds_to_thousands <= 1;
        end else begin
            ena_hundreds_to_thousands <= 0;
        end
        
        // Increment the thousands digit when the hundreds digit overflows
        if (ena_hundreds_to_thousands) begin
            thousands <= thousands + 1;
        end
        
        // Check for overflow in the thousands digit
        if (thousands == 10) begin
            thousands <= 0;
        end
    end
end

// Assign the internal signals to the output ports
assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;
assign ena[0] = ena_ones_to_tens;
assign ena[1] = ena_tens_to_hundreds;
assign ena[2] = ena_hundreds_to_thousands;

endmodule
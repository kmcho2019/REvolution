module TopModule (
    input       clk,      // clock signal
    input       reset,    // active high synchronous reset
    input [7:0] d,        // 8-bit input
    output [7:0] q        // 8-bit output
);

// Define the initial value for reset as a parameter
parameter RESET_VALUE = 8'h34;

// Declare a register to hold the output value
reg [7:0] q;

// Use always block with negedge to trigger on the negative edge of clk
always @(negedge clk) begin
    if (reset) begin
        // Reset q to the predefined value when reset is high
        q <= RESET_VALUE;
    end else begin
        // Assign input d to output q when reset is low
        q <= d;
    end
end

endmodule
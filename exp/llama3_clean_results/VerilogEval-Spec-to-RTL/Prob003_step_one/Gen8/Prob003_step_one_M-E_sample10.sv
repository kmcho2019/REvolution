module TopModule (
    output one
);
// Define the output as a reg to be used within an always block
reg one;

// Use a clocked always block to drive the output high
always @(posedge clk) begin
    one <= 1'b1;
end

// Note: For this example to work, a clock signal 'clk' needs to be defined.
// In a real design, this clock signal would be an input to the module.
// For simplicity and to adhere to the original problem statement, the clock input is not included here.

endmodule
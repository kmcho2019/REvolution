// Define a simplified module for driving a constant value.
module TopModule (
    output logic one // Output port with fixed width of 1
);

// Directly assign the constant value to the output.
assign one = 1'b1; // Assign 1 to the output.

endmodule
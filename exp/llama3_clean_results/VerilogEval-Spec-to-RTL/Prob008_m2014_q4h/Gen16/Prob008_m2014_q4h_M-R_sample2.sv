// Refactored Module TopModule: Using an always block for combinational logic.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Use an always block for the combinational assignment
always @(*) begin
    out = in;  // Directly assign the input to the output
end

endmodule
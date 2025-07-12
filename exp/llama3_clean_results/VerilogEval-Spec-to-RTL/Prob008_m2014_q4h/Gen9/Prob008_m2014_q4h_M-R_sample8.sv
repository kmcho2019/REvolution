// Module TopModule: A simple combinational logic circuit that assigns the output port 'out' to the same value as the input port 'in'.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Use an always block with a sensitivity list that includes all inputs (@(*)) to mimic combinational logic behavior.
always @(*) begin
    // Within this block, directly assign the value of 'in' to 'out'.
    out = in;
end

// This refactored module maintains the same functionality as the original but uses a procedural assignment within an always block.
// The @(*) syntax ensures the block is sensitive to changes in all inputs, effectively making it combinational.

endmodule
// Module TopModule: A simple combinational logic circuit that assigns the output port 'out' to the same value as the input port 'in'.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Use an always block with sensitivity to 'in' to assign 'in' to 'out'.
always @(*) begin
    // Within this block, 'out' is directly assigned the value of 'in'.
    out = in;
end

// This refactored version maintains the same functionality as the original but uses an always block instead of a continuous assignment.
// It's essential to note that for purely combinational logic, both methods are functionally equivalent, but the choice between them might depend on the specific requirements of the design or personal preference.

endmodule
// Refactored solution using an always block for combinational logic.
module TopModule(
    input a,
    input b,
    input c,
    output reg out // Declare out as a reg for use within always block
);

always @(*) // Sensitivity list for all inputs
begin
    // Directly implement the simplified OR logic for simplicity and efficiency.
    out = a | b | c;
end

endmodule
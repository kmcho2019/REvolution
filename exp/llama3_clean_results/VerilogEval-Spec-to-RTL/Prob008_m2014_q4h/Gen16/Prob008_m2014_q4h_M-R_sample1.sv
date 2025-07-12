// Module TopModule: Refactored implementation using an always block for combinational logic.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Use an always block for combinational logic
always @(*) begin
    out = in; // Directly assign input to output
end

endmodule
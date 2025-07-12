// Module TopModule: MUX-based implementation
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Internal signal for the MUX's select line
logic sel;

// Assign a constant value to the select signal
assign sel = 1'b0;

// Use a MUX to select between the input and its inverse
assign out = sel ? ~in : in;

endmodule
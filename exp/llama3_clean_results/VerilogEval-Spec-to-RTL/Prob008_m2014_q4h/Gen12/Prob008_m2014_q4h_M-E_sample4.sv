// Module TopModule: An alternative implementation using NOT-NOT gates.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Internal wire to connect the two NOT gates
logic not_in;

// First NOT gate inverts the input
assign not_in = ~in;

// Second NOT gate inverts the result back to the original input
assign out = ~not_in;

endmodule
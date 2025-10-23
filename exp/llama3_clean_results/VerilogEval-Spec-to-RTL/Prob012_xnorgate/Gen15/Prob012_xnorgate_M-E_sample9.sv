// Novel XNOR gate implementation using a lookup table
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Define a lookup table for the XNOR operation
// Since we're dealing with binary inputs, we can use a small case statement
// to mimic the behavior of a LUT or ROM
always @(*) begin
    case ({a, b})
        2'b00: out = 1'b1; // Both inputs are 0, XNOR outputs 1
        2'b01: out = 1'b0; // Inputs are different, XNOR outputs 0
        2'b10: out = 1'b0; // Inputs are different, XNOR outputs 0
        2'b11: out = 1'b1; // Both inputs are 1, XNOR outputs 1
        default: out = 1'bx; // Invalid input combination, output undefined
    endcase
end

endmodule
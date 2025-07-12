// Module TopModule implements a simple logic circuit using a lookup table approach.
// The output 'out' is determined based on the input combinations of 'in1' and 'in2'.
module TopModule(
    input  in1,  // First input to the circuit
    input  in2,  // Second input to the circuit
    output out   // Output of the circuit
);

// Use a case statement to implement the lookup table
always @(in1, in2) begin
    case ({in1, in2})
        2'b00: out = 1'b0; // in1 = 0, in2 = 0
        2'b01: out = 1'b0; // in1 = 0, in2 = 1
        2'b10: out = 1'b1; // in1 = 1, in2 = 0
        2'b11: out = 1'b0; // in1 = 1, in2 = 1
        default: out = 1'b0; // Default case for any other combination
    endcase
end

endmodule
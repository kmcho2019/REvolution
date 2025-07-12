// Novel module TopModule implements a NOR gate using a Look-Up Table (LUT) approach.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Use a case statement to mimic a LUT, where each input combination corresponds to a specific output value.
always_comb begin
    case ({a, b})
        2'b00: out = 1'b1;  // Both inputs are 0, output is 1 (NOR operation)
        2'b01, 2'b10, 2'b11: out = 1'b0;  // At least one input is 1, output is 0 (NOR operation)
        default: out = 1'bx;  // Default case to handle any unexpected input combinations
    endcase
end

endmodule
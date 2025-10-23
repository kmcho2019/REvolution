module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

    // Use a case statement to implement the LUT for the NOR gate
    always_comb begin
        case ({a, b})  // Combine inputs a and b into a single 2-bit value
            2'b00: out = 1'b1;  // For input 00, output is 1
            2'b01: out = 1'b0;  // For input 01, output is 0
            2'b10: out = 1'b0;  // For input 10, output is 0
            2'b11: out = 1'b0;  // For input 11, output is 0
            default: out = 1'bx;  // For any other input, output is undefined (should not occur)
        endcase
    end

endmodule
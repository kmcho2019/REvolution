module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

    // LUT (Lookup Table) for NOR gate
    // Input combinations: 00, 01, 10, 11
    // Corresponding outputs: 1, 0, 0, 0
    always_comb begin
        case ({a, b})  // Concatenate inputs a and b
            2'b00: out = 1'b1;  // Output for input combination 00
            2'b01: out = 1'b0;  // Output for input combination 01
            2'b10: out = 1'b0;  // Output for input combination 10
            2'b11: out = 1'b0;  // Output for input combination 11
            default: out = 1'b0;  // Default output
        endcase
    end

endmodule
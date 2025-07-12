// Module declaration for a simple AND gate
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic q   // Output signal q
);

    // Direct assignment for simplicity and efficiency
    // The output q is assigned the logical AND of inputs a and b
    assign q = a && b;

    // Alternative implementation using an always_comb block
    // always_comb begin
    //     case({a, b})
    //         2'b00: q = 1'b0;
    //         2'b01: q = 1'b0;
    //         2'b10: q = 1'b0;
    //         2'b11: q = 1'b1;
    //         default: q = 1'bx; // default case for handling unknown inputs
    //     endcase
    // end

endmodule
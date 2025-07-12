// Module declaration for a simple AND gate
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic q   // Output signal q
);

    // Direct assignment for simplicity and efficiency
    // The output q is assigned the logical AND of inputs a and b
    assign q = a && b;

    // For more complex designs, consider using an always block
    // for clarity and easier management of combinational logic
    // always @(*) begin
    //     q = a & b;
    // end

endmodule
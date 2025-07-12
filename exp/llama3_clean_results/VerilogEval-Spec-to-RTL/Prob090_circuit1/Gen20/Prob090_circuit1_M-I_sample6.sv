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

    // To further optimize power in more complex designs, consider techniques such as:
    // - Clock gating: Dynamically enabling/disabling clock signals to parts of the design that are not in use.
    // - Using low-power library cells: Many standard cell libraries include low-power versions of cells that can be used to reduce power consumption.
    // - Logic minimization: Simplifying the logic to reduce the number of gates and transitions, thereby reducing power consumption.

endmodule
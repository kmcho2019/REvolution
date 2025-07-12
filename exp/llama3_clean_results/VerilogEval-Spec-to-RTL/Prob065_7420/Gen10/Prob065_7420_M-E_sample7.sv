// Define a parameterized module for an n-input NAND gate
module NANDn(
    parameter n = 4, // Default number of inputs is 4
    input [n-1:0] inputs,
    output y
);
    // Use a generate block to handle the inputs
    wire [n-1:0] inv_inputs; // Inverted inputs
    genvar i;
    generate
        for (i = 0; i < n; i++) begin
            // Invert each input
            assign inv_inputs[i] = ~inputs[i];
        end
    endgenerate
    
    // Assign y as the conjunction of all inverted inputs
    assign y = &inv_inputs; // & operator performs a bitwise AND reduction
endmodule

// Instantiate the NANDn module twice within the TopModule
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);
    // Instantiate NANDn modules for the first and second sets of inputs
    // Packing inputs into a vector for the NANDn module
    wire [3:0] p1_inputs = {p1a, p1b, p1c, p1d};
    wire [3:0] p2_inputs = {p2a, p2b, p2c, p2d};
    
    NANDn #(.n(4)) nand1(
        .inputs(p1_inputs),
        .y(p1y)
    );
    
    NANDn #(.n(4)) nand2(
        .inputs(p2_inputs),
        .y(p2y)
    );
endmodule
// Define a generic n-input NAND gate module
module NANDn(
    input [7:0] inputs, // Assume up to 8 inputs for simplicity
    output y
);

    // Internal wire to hold the result of the NAND operation
    wire [7:0] nand_result;

    // Initialize nand_result with all ones (assuming all inputs are active high)
    assign nand_result[0] = ~inputs[0];

    // Compute the NAND of all inputs using a for loop
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign nand_result[i] = nand_result[i-1] & ~inputs[i];
        end
    endgenerate

    // Assign the final result to output y
    // Assuming we are using the first 4 inputs for the 7420 functionality
    assign y = nand_result[3];

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

    // Internal wires to connect inputs to NANDn modules
    wire [7:0] inputs1, inputs2;

    // Assign inputs to the first NANDn module
    assign inputs1[0] = p1a;
    assign inputs1[1] = p1b;
    assign inputs1[2] = p1c;
    assign inputs1[3] = p1d;
    assign inputs1[4] = 1'b1; // Unused inputs set to 1 (active high)
    assign inputs1[5] = 1'b1;
    assign inputs1[6] = 1'b1;
    assign inputs1[7] = 1'b1;

    // Assign inputs to the second NANDn module
    assign inputs2[0] = p2a;
    assign inputs2[1] = p2b;
    assign inputs2[2] = p2c;
    assign inputs2[3] = p2d;
    assign inputs2[4] = 1'b1; // Unused inputs set to 1 (active high)
    assign inputs2[5] = 1'b1;
    assign inputs2[6] = 1'b1;
    assign inputs2[7] = 1'b1;

    // Instantiate NANDn modules for the first and second sets of inputs
    NANDn nand1(
        .inputs(inputs1),
        .y(p1y)
    );

    NANDn nand2(
        .inputs(inputs2),
        .y(p2y)
    );

endmodule
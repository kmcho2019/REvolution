module TopModule(input logic x, input logic y, output logic z);
    // Shared intermediate signals
    logic x_xor_y;
    logic x_and_y;

    assign x_xor_y = x ^ y;
    assign x_and_y = x & y;

    // Outputs of the four "submodules"
    logic A_out [1:2];
    logic B_out [1:2];

    // Generate block to create logic resembling two A and two B modules
    genvar i;
    generate
        for (i=1; i<=2; i=i+1) begin : submodules
            // A module logic: (x ^ y) & x
            assign A_out[i] = x_xor_y & x;
            // B module logic: ~(x ^ y)
            assign B_out[i] = ~x_xor_y;
        end
    endgenerate

    // Compute OR and AND of the first and second pair outputs respectively
    logic or_out;
    logic and_out;

    assign or_out = A_out[1] | B_out[1];
    assign and_out = A_out[2] & B_out[2];

    // Final output is XOR of or_out and and_out
    assign z = or_out ^ and_out;
endmodule
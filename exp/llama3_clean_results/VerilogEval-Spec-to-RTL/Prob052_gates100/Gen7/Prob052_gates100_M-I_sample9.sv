module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Initialize output variables
    assign out_and = 1'b1;
    assign out_or = 1'b0;
    assign out_xor = 1'b0;

    // Perform the AND, OR, and XOR operations on the input vector
    for (genvar i = 0; i < 100; i++) begin
        assign out_and = out_and & in[i];
        assign out_or = out_or | in[i];
        assign out_xor = out_xor ^ in[i];
    end

endmodule
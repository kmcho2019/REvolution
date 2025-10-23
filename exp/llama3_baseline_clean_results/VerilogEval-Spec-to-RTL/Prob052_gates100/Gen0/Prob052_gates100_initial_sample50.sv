module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    reg and_temp;
    reg or_temp;
    reg xor_temp;

    always @(*) begin
        // Initialize AND output to 1
        and_temp = 1'b1;
        // Initialize OR output to 0
        or_temp = 1'b0;
        // Initialize XOR output to 0
        xor_temp = 1'b0;

        // Iterate over all inputs
        for (int i = 0; i < 100; i++) begin
            // Perform AND operation
            and_temp = and_temp & in[i];
            // Perform OR operation
            or_temp = or_temp | in[i];
            // Perform XOR operation
            xor_temp = xor_temp ^ in[i];
        end

        // Assign outputs
        out_and = and_temp;
        out_or = or_temp;
        out_xor = xor_temp;
    end

endmodule
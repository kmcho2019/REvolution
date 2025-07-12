module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg [99:0] in_reg; // Internal register to hold input
reg and_out;       // Internal register to hold AND output
reg or_out;        // Internal register to hold OR output
reg xor_out;       // Internal register to hold XOR output

always @(*) begin
    and_out = 1'b1; // Initialize AND output to 1
    or_out = 1'b0;  // Initialize OR output to 0
    xor_out = 1'b0; // Initialize XOR output to 0

    // Iterate over 100 input bits
    for (int i = 0; i < 100; i++) begin
        and_out = and_out & in[i]; // Perform AND operation
        or_out = or_out | in[i];   // Perform OR operation
        xor_out = xor_out ^ in[i]; // Perform XOR operation
    end

    // Assign outputs
    out_and = and_out;
    out_or = or_out;
    out_xor = xor_out;
end

endmodule
module TopModule (
    input clk,
    input x,
    output z
);

    // Internal reset to initialize flip-flops on first clock cycle
    reg internal_reset = 1'b1;

    reg ff_xor;
    reg ff_and;
    reg ff_or;

    wire d_xor;
    wire d_and;
    wire d_or;

    // Compute next states per problem description
    assign d_xor = x ^ ff_xor;
    assign d_and = x & (~ff_and);
    assign d_or  = x | (~ff_or);

    always @(posedge clk) begin
        if (internal_reset) begin
            // Initialize flip-flops to zero on first clock cycle
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
            internal_reset <= 1'b0; // De-assert reset after first cycle
        end else begin
            ff_xor <= d_xor;
            ff_and <= d_and;
            ff_or  <= d_or;
        end
    end

    // Output is NOR of flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule
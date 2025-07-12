module TopModule (
    input clk,
    input x,
    output z
);

    reg ff_xor, ff_and, ff_or;
    reg reset;

    // Synchronous reset asserted once at start for initialization
    initial reset = 1'b1;
    always @(posedge clk) begin
        if (reset)
            reset <= 1'b0;
    end

    always @(posedge clk) begin
        if (reset) begin
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
        end else begin
            // Compute D inputs inside sequential block for clarity
            ff_xor <= x ^ ff_xor;
            ff_and <= x & (~ff_and);
            ff_or  <= x | (~ff_or);
        end
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule
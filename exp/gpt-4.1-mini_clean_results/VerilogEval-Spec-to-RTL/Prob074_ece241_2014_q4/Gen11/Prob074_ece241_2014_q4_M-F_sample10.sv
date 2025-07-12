module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    // Internal synchronous reset signal asserted only on first clock cycle
    reg reset_sync = 1'b1;

    always @(posedge clk) begin
        if (reset_sync)
            reset_sync <= 1'b0;
    end

    // Combinational logic for the D inputs of the flip-flops
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Sequential logic with synchronous reset on reset_sync
    always @(posedge clk) begin
        if (reset_sync) begin
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
        end else begin
            ff_xor <= d_xor;
            ff_and <= d_and;
            ff_or  <= d_or;
        end
    end

    // Output is the NOR of the flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule
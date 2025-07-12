module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;
    reg init_done = 0; // Internal init done flag to generate synchronous reset on first clock

    wire reset_sync = ~init_done; // Active high synchronous reset for first clock cycle

    wire d_xor = x ^ ff_xor;
    wire d_and = x & ~ff_and;
    wire d_or  = x | ~ff_or;

    always @(posedge clk) begin
        if (reset_sync) begin
            // Initialize all flip-flops to zero synchronously on first clock
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
            init_done <= 1'b1;
        end else begin
            ff_xor <= d_xor;
            ff_and <= d_and;
            ff_or  <= d_or;
        end
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule
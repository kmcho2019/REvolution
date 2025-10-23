module TopModule (
    input clk,
    input rst,   // synchronous reset input
    input x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    // Compute D inputs for the flip-flops
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Sequential logic: update flip-flops on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
        end else begin
            ff_xor <= d_xor;
            ff_and <= d_and;
            ff_or  <= d_or;
        end
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule
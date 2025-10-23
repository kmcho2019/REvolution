module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    // Initialize flip-flops to zero before simulation starts
    initial begin
        ff_xor = 0;
        ff_and = 0;
        ff_or  = 0;
    end

    // Combinational logic for the D inputs of the flip-flops
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Update flip-flops on the positive edge of clock
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // Output is the NOR of the flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule
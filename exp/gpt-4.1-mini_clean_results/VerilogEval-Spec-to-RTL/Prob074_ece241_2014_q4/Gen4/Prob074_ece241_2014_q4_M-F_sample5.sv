module TopModule (
    input  clk,
    input  x,
    input  reset,  // Added synchronous reset input
    output z
);

    reg ff_xor, ff_and, ff_or; // individual flip-flops

    wire d_xor, d_and, d_or;

    // Combinational logic for next states:
    // XOR gate: d_xor = x XOR ff_xor
    assign d_xor = x ^ ff_xor;

    // AND gate: d_and = x AND (~ff_and)
    assign d_and = x & (~ff_and);

    // OR gate: d_or = x OR (~ff_or)
    assign d_or = x | (~ff_or);

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
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
module TopModule (
    input clk,
    input x,
    output z
);

    // Three separate D flip-flops
    reg dff_xor = 1'b0;
    reg dff_and = 1'b0;
    reg dff_or = 1'b0;

    // Gate outputs with their specific feedback paths
    wire xor_out = x ^ dff_xor;
    wire and_out = x & ~dff_and;
    wire or_out = x | ~dff_or;

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        dff_xor <= xor_out;
        dff_and <= and_out;
        dff_or <= or_out;
    end

    // Final output is NOR of all flip-flop outputs
    assign z = ~(dff_xor | dff_and | dff_or);

endmodule
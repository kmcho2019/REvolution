module DFF_with_sync_reset (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  x,
    output z
);
    // Internal reset signal for flip-flops initialization
    reg reset;

    // Flip-flop outputs
    wire q_xor, q_and, q_or;

    // Instantiate three D flip-flops with synchronous reset
    DFF_with_sync_reset dff_xor (
        .clk(clk),
        .reset(reset),
        .d(x ^ q_xor),
        .q(q_xor)
    );

    DFF_with_sync_reset dff_and (
        .clk(clk),
        .reset(reset),
        .d(x & (~q_and)),
        .q(q_and)
    );

    DFF_with_sync_reset dff_or (
        .clk(clk),
        .reset(reset),
        .d(x | (~q_or)),
        .q(q_or)
    );

    // NOR gate for output z
    assign z = ~(q_xor | q_and | q_or);

    // Generate synchronous reset signal at start for initialization
    // This assumes initial block is allowed for simulation; synthesis tools may ignore it.
    initial begin
        reset = 1'b1;
        #1;      // hold reset high for 1 time unit to ensure flip-flops clear
        reset = 1'b0;
    end

endmodule
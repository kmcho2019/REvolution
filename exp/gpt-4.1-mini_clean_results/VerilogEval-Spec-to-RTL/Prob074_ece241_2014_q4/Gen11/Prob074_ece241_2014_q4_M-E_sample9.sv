module DFF_sync_reset (
    input clk,
    input reset,    // synchronous active-high reset
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
    input clk,
    input x,
    output z
);

    // Internal signal to generate a synchronous reset for initial power-on reset
    reg init_done;

    always @(posedge clk) begin
        if (!init_done)
            init_done <= 1'b1;  // After first clock, init_done set
    end

    wire reset_sync = ~init_done; // active-high reset for one cycle after power-on

    // Wires for flip-flop outputs
    wire q_xor, q_and, q_or;

    // Compute D inputs for flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Instantiate three D flip-flops with synchronous reset
    DFF_sync_reset dff_xor (
        .clk(clk),
        .reset(reset_sync),
        .d(d_xor),
        .q(q_xor)
    );

    DFF_sync_reset dff_and (
        .clk(clk),
        .reset(reset_sync),
        .d(d_and),
        .q(q_and)
    );

    DFF_sync_reset dff_or (
        .clk(clk),
        .reset(reset_sync),
        .d(d_or),
        .q(q_or)
    );

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
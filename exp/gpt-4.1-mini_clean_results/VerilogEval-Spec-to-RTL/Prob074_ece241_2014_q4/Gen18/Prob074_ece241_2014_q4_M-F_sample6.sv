module TopModule (
    input clk,
    input x,
    output z
);
    // Synchronous reset signal initialized to 1 at start to reset flip-flops
    reg reset;

    // Flip-flop outputs packed into 3-bit register:
    // q[2]: q_xor, q[1]: q_and, q[0]: q_or
    reg [2:0] q;

    // Compute D inputs based on current state q
    wire q_xor = q[2];
    wire q_and = q[1];
    wire q_or  = q[0];

    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Initialize reset to 1 at simulation start
    initial reset = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000;
            reset <= 1'b0; // De-assert reset after first clock
        end else begin
            q <= {d_xor, d_and, d_or};
        end
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q[2] | q[1] | q[0]);

endmodule
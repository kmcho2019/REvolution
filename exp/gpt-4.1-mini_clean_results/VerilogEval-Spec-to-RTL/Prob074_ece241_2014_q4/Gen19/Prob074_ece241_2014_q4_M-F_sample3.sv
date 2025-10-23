module TopModule (
    input clk,
    input x,
    output z
);
    // Flip-flop outputs packed into 3-bit register:
    // q[2]: q_xor, q[1]: q_and, q[0]: q_or
    reg [2:0] q = 3'b000;  // Initialized to zero at start

    // Current flip-flop outputs
    wire q_xor = q[2];
    wire q_and = q[1];
    wire q_or  = q[0];

    // Compute D inputs based on current q values and input x
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    always @(posedge clk) begin
        q <= {d_xor, d_and, d_or};  // Update flip-flops synchronously
    end

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
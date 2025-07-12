module TopModule (
    input clk,
    input x,
    output z
);
    // Internal synchronous reset signal for initialization
    reg reset_done;

    // Flip-flop outputs packed into a 3-bit register:
    // bit 2: q_xor, bit 1: q_and, bit 0: q_or
    reg [2:0] q;

    // Combinational logic signals for D inputs
    wire q_xor = q[2];
    wire q_and = q[1];
    wire q_or  = q[0];

    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Synchronous reset on first clock cycle
    // Implement reset_done as a simple start-up flag after first clock
    always @(posedge clk) begin
        if (!reset_done) begin
            q <= 3'b000;
            reset_done <= 1'b1;
        end else begin
            q[2] <= d_xor;
            q[1] <= d_and;
            q[0] <= d_or;
        end
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q[2] | q[1] | q[0]);

endmodule
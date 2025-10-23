module TopModule (
    input clk,
    input x,
    output reg z
);

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Initialize flip-flops to zero at simulation start
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    always @(posedge clk) begin
        // D input computations per problem statement:
        // XOR flip-flop: d_xor = x XOR q_xor
        q_xor <= x ^ q_xor;

        // AND flip-flop: d_and = x AND (~q_and)
        q_and <= x & (~q_and);

        // OR flip-flop: d_or = x OR (~q_or)
        q_or <= x | (~q_or);
    end

    // Combinational output logic: z is NOR of the three flip-flop outputs
    always @(*) begin
        z = ~(q_xor | q_and | q_or);
    end

endmodule
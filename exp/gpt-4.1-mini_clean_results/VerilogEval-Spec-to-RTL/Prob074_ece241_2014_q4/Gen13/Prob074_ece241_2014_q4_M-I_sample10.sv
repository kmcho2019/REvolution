module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal power-on reset generation: reset asserted for first 2 clocks
    reg [1:0] reset_sync = 2'b11; // start reset asserted
    wire reset = reset_sync[1];

    always @(posedge clk) begin
        reset_sync <= {reset_sync[0], 1'b0};
    end

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Synchronous reset flip-flops
    always @(posedge clk) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            // Compute D inputs per problem statement
            // XOR flip-flop: d_xor = x XOR q_xor
            q_xor <= x ^ q_xor;

            // AND flip-flop: d_and = x AND (~q_and)
            q_and <= x & (~q_and);

            // OR flip-flop: d_or = x OR (~q_or)
            q_or <= x | (~q_or);
        end
    end

    // Output logic: z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
module TopModule (
    input  clk,
    input  x,
    output z
);

    // Flip-flop outputs as registers
    reg q_xor, q_and, q_or;

    // Internal synchronous initialization signal, starts at 1
    reg init = 1'b1;

    // Combinational logic for D inputs of flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    always @(posedge clk) begin
        if (init) begin
            // Synchronously reset all flip-flops at startup
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            init  <= 1'b0;  // Clear init after first clock
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
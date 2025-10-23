module TopModule (
    input  clk,
    input  x,
    output z
);
    // State registers, initialized to zero
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    // Next state combinational logic
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Sequential logic: flip-flops updated on posedge clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is NOR of flip-flops outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
module TopModule (
    input  clk,
    input  x,
    output z
);

    // Separate registers for each flip-flop output
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    // Combinational logic for D inputs based on current flip-flop states and input x
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is the NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
module TopModule (
    input  clk,
    input  reset_n,  // active-low asynchronous reset
    input  x,
    output z
);

    reg q_xor, q_and, q_or;

    // Combinational D inputs for flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    // Sequential logic: flip-flops with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
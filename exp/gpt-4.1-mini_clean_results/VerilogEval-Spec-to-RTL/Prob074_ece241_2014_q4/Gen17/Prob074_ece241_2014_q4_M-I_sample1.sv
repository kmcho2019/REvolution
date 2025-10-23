module TopModule (
    input clk,
    input reset,  // synchronous reset input to initialize flip-flops to zero
    input x,
    output z
);

    // Flip-flop outputs
    reg q_xor;
    reg q_and;
    reg q_or;

    // Combinational logic for next D inputs
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops updating on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
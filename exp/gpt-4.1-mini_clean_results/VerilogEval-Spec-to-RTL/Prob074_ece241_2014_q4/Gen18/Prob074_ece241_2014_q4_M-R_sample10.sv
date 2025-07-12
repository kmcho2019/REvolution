module TopModule (
    input clk,
    input x,
    output z
);

    // Internal synchronous reset: asserted initially, de-asserted after first clock edge
    reg reset_n;
    initial reset_n = 1'b0; // reset active low at start
    always @(posedge clk)
        reset_n <= 1'b1;

    // State registers for flip-flops
    reg q_xor, q_and, q_or;

    // Combinational D inputs for the flip-flops according to problem logic
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops with synchronous active-low reset
    always @(posedge clk) begin
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

    // Output z is NOR of all three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
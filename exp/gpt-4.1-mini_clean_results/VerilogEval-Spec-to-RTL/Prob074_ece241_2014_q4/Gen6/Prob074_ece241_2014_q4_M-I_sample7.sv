module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal asynchronous active-low reset signal
    reg resetn;

    // Flip-flop state registers with async reset
    reg q_xor, q_and, q_or;

    // Combinational logic for the D inputs of flip-flops
    wire d_xor = x ^ q_xor;      // XOR gate: x and q_xor
    wire d_and = x & (~q_and);   // AND gate: x and complement of q_and
    wire d_or  = x | (~q_or);    // OR gate: x and complement of q_or

    // Initialize the asynchronous reset signal to 0, then release after a delta cycle
    initial begin
        resetn = 1'b0;
        #1 resetn = 1'b1;
    end

    // Flip-flops with asynchronous reset (active low)
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
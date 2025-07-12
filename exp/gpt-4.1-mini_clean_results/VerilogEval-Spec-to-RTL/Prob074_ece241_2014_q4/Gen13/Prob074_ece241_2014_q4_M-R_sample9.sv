module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal synchronous reset signal, asserted for one cycle after power-up
    reg [1:0] reset_shift = 2'b11; // Initialized high at power-up (simulation/synthesis)
    wire reset = reset_shift[1];

    // Shift register to deassert reset after two clock cycles
    always @(posedge clk) begin
        reset_shift <= {reset_shift[0], 1'b0};
    end

    // Flip-flops
    reg q_xor;
    reg q_and;
    reg q_or;

    // Combinational logic for D inputs
    wire d_xor = x ^ q_xor;    // XOR with q_xor
    wire d_and = x & (~q_and); // AND with complemented q_and
    wire d_or  = x | (~q_or);  // OR with complemented q_or

    // Sequential logic with synchronous internal reset
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

    // Output z is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
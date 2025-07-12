module TopModule (
    input  clk,
    input  x,
    output z
);
    reg q_xor, q_and, q_or;
    reg reset_n;

    // For simulation: asynchronous reset generation (active low)
    // Flip-flops initialized to zero at start
    initial begin
        reset_n = 1'b0;
        #1;
        reset_n = 1'b1;
    end

    // Combinational logic for D inputs
    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    // Sequential logic with synchronous active-low reset
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
module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop state registers with asynchronous reset
    reg q_xor, q_and, q_or;

    // Asynchronous reset signal asserted at start (power-on reset)
    reg reset_n;

    initial begin
        reset_n = 1'b0;    // Assert reset at time 0
        #1 reset_n = 1'b1; // Deassert reset shortly after time 0
    end

    // D input signals derived from current input and flip-flop outputs
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops with asynchronous active-low reset
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

    // Output z is the NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
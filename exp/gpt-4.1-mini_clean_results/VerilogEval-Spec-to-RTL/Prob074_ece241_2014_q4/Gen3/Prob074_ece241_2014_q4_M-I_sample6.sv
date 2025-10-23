module TopModule (
    input  clk,
    input  x,
    output z
);
    reg q_xor, q_and, q_or;
    reg reset_async = 1'b1;  // asynchronous reset asserted at power-up

    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    // Release async reset synchronously on first clock edge
    always @(posedge clk or posedge reset_async) begin
        if (reset_async) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Deassert asynchronous reset after first clock edge
    always @(posedge clk) begin
        if (reset_async)
            reset_async <= 1'b0;
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule
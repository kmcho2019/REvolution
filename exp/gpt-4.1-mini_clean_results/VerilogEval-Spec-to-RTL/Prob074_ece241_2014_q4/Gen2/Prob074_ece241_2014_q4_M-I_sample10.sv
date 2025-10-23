module TopModule (
    input  clk,
    input  x,
    output z
);
    reg q_xor, q_and, q_or;
    reg reset; // synchronous reset signal

    // At power on, reset is asserted, then cleared after first clock cycle
    initial reset = 1'b1;

    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    always @(posedge clk) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            reset <= 1'b0; // release reset after first clock cycle
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule
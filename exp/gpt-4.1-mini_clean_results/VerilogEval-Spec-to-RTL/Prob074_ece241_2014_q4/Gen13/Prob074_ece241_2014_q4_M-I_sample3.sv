module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor, q_and, q_or;
    reg init_done;

    // Synchronous reset logic performed once at startup
    always @(posedge clk) begin
        if (!init_done) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            init_done <= 1'b1;
        end else begin
            q_xor <= x ^ q_xor;
            q_and <= x & ~q_and;
            q_or  <= x | ~q_or;
        end
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule
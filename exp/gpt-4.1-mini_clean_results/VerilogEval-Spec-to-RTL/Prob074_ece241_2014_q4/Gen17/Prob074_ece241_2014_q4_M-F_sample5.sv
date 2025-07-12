module TopModule (
    input clk,
    input reset_n, // active low synchronous reset
    input x,
    output z
);
    reg q_xor, q_and, q_or;

    always @(posedge clk) begin
        if (~reset_n) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= x ^ q_xor;
            q_and <= x & (~q_and);
            q_or  <= x | (~q_or);
        end
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule
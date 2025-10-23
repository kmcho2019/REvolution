module TopModule(
    input clk,
    input x,
    output z
);

reg q_x, q_and, q_or;
wire w_xor, w_and, w_or;

assign w_xor = x ^ q_x;
assign w_and = x & ~q_and;
assign w_or = x | ~q_or;

always @(posedge clk) begin
    q_x <= w_xor;
    q_and <= w_and;
    q_or <= w_or;
end

assign z = ~(w_xor | w_and | w_or);

endmodule
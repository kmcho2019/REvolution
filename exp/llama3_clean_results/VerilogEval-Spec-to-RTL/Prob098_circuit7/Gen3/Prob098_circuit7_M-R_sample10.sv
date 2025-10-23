module TopModule(
    input  clk,
    input  a,
    output q
);

reg q_reg; // Using a single-bit reg to represent the state
assign q = q_reg;

always @(posedge clk) begin
    if (a) begin
        q_reg <= ~q_reg; // Toggle the state when a is 1
    end else begin
        q_reg <= q_reg; // Keep the state the same when a is 0
    end
end

initial begin
    q_reg = 1'b1; // Initialize state to 'one' at start
end

endmodule
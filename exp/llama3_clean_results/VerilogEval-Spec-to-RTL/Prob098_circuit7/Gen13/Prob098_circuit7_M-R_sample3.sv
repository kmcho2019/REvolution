module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1'b1; // Explicit initialization to match the original simulation
always @(posedge clk) begin
    q <= ~a;
end

endmodule
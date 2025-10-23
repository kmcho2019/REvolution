module TopModule (
    input  clk,
    input  a,
    output reg q
);

wire inv_a;
assign inv_a = ~a;

always @(posedge clk) begin
    q <= inv_a;
end

endmodule
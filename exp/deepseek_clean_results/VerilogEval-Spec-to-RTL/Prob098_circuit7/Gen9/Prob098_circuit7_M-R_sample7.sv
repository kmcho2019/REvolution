module TopModule (
    input clk,
    input a,
    output q
);

wire d;
assign d = ~a;

always @(posedge clk) begin
    q <= d;
end

endmodule
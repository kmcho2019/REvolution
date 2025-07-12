module TopModule(
    input clk,
    input a,
    output reg q = 1'b1
);

always @(posedge clk) begin
    q = ~a;
end

endmodule
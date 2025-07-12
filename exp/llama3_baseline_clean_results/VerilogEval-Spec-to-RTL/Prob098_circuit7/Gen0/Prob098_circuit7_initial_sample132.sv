module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1'b0;

always @(posedge clk) begin
    if (a == 1'b1) begin
        q <= ~q;
    end else begin
        q <= q;
    end
end

endmodule
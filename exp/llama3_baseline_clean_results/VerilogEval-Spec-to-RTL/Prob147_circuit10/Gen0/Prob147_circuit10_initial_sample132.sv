module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= q;
    if (b == 1'b1) begin
        q <= 1'b1;
    end else begin
        q <= a;
    end
end

endmodule
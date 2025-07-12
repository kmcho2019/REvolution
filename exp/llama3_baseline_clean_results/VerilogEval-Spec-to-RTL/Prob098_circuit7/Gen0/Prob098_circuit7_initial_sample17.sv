module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q;
    end else begin
        q <= 1;
    end
end

initial begin
    q = 1;
end

endmodule
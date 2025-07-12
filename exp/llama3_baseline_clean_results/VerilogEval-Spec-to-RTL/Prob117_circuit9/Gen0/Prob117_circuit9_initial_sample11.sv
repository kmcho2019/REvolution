module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (~a) begin
        if (q == 3'd7) begin
            q <= 3'd0;
        end else begin
            q <= q + 1'b1;
        end
    end
end

initial begin
    q = 3'd4;
end

endmodule
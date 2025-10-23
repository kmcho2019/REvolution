module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4'd4;
    end else begin
        q <= (q == 6) ? 3'd0 : q + 1;
    end
end

initial begin
    q <= 4'd4;
end

endmodule
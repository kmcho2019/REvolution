module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg q_bar;

always @(posedge clk) begin
    if (k) begin
        q_bar <= ~Q;
    end else begin
        q_bar <= Q;
    end
end

always @(posedge clk) begin
    if (j) begin
        Q <= k? ~Q : 1'b1;
    end else begin
        Q <= q_bar;
    end
end

endmodule
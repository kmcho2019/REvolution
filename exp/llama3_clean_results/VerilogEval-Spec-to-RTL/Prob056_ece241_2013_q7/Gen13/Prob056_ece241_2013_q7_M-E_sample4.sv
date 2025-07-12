module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg D;

always @(j, k, Q) begin
    if (j == 1'b0 && k == 1'b0) begin
        D = Q;
    end else if (j == 1'b0 && k == 1'b1) begin
        D = 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        D = 1'b1;
    end else begin
        D = ~Q;
    end
end

always @(posedge clk) begin
    Q <= D;
end

endmodule
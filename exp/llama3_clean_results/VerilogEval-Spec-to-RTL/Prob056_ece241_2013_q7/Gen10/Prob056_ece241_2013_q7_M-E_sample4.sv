module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg T;

always @(posedge clk) begin
    if (~j & ~k) begin
        T <= 1'b0;
    end else if (~j & k) begin
        T <= 1'b1;
    end else if (j & ~k) begin
        T <= 1'b1;
    end else if (j & k) begin
        T <= 1'b1;
    end
end

always @(posedge clk) begin
    Q <= Q ^ T;
end

endmodule
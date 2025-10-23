module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Qold;

always @(*) begin
    Qold = Q;
end

always @(posedge clk) begin
    if (~j & ~k) begin
        Q <= Qold;
    end else if (~j & k) begin
        Q <= 1'b0;
    end else if (j & ~k) begin
        Q <= 1'b1;
    end else if (j & k) begin
        Q <= ~Qold;
    end
end

endmodule
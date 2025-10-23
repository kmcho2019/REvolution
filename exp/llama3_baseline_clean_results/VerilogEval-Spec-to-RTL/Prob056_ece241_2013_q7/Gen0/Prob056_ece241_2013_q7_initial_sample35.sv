module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (~j & ~k) begin
        Q <= Q; // No change, so Qold is the same as Qnew
    end else if (~j & k) begin
        Q <= 1'b0;
    end else if (j & ~k) begin
        Q <= 1'b1;
    end else if (j & k) begin
        Q <= ~Q; // Qnew is the inverse of Qold
    end
end

endmodule
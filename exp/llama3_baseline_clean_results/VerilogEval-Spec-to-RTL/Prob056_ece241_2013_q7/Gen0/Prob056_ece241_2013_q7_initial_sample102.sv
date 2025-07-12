module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (~j & ~k) begin
        Q <= Q;  // No change
    end else if (~j & k) begin
        Q <= 1'b0;  // Reset Q to 0
    end else if (j & ~k) begin
        Q <= 1'b1;  // Set Q to 1
    end else begin
        Q <= ~Q;  // Toggle Q
    end
end

endmodule
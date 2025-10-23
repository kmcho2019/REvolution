module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (~j & ~k) begin
        Q <= Q; // No change
    end else if (~j & k) begin
        Q <= 1'b0; // Reset
    end else if (j & ~k) begin
        Q <= 1'b1; // Set
    end else if (j & k) begin
        Q <= ~Q; // Toggle
    end
end

endmodule
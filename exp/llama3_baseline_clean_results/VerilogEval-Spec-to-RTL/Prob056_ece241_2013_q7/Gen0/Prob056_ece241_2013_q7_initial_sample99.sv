module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (~j & ~k) begin
        Q <= Q; // Qold (no change)
    end else if (~j & k) begin
        Q <= 1'b0; // reset
    end else if (j & ~k) begin
        Q <= 1'b1; // set
    end else if (j & k) begin
        Q <= ~Q; // toggle
    end
end

endmodule
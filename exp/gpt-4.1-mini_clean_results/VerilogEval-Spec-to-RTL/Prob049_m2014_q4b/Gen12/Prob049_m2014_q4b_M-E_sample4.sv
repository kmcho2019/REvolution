module TopModule (
    input clk,
    input ar,    // Asynchronous active-high reset
    input d,
    output reg q
);

reg q_reg;

// Asynchronous reset logic: if ar is asserted, immediately reset q_reg to 0
always @(ar or q_reg) begin
    if (ar) begin
        q_reg = 1'b0;
    end
end

// Positive edge clock to latch d into q_reg only if not in reset
always @(posedge clk) begin
    if (!ar) begin
        q_reg <= d;
    end
end

// Output driven by internal register
always @(*) begin
    q = q_reg;
end

endmodule
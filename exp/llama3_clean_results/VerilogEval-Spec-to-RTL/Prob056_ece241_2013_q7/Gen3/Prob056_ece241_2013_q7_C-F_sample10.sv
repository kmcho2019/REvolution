module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        Q <= Q; // Directly assign Q to itself for clarity
    end else if (j == 1'b0 && k == 1'b1) begin
        Q <= 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        Q <= 1'b1;
    end else if (j == 1'b1 && k == 1'b1) begin
        Q <= ~Q; // Use non-blocking assignment for sequential logic
    end
end

endmodule
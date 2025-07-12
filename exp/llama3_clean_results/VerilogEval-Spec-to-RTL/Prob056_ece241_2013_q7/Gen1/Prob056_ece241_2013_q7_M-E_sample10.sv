module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0) begin
        if (k == 0) begin
            Q <= Q; // No change
        end else begin
            Q <= 0; // Reset
        end
    end else begin
        if (k == 0) begin
            Q <= 1; // Set
        end else begin
            Q <= ~Q; // Toggle
        end
    end
end

endmodule
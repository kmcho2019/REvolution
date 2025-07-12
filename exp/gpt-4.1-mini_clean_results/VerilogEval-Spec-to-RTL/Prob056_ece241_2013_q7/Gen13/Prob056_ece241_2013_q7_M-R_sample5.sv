module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        // No change
        Q <= Q;
    end else if (j == 0 && k == 1) begin
        // Reset
        Q <= 1'b0;
    end else if (j == 1 && k == 0) begin
        // Set
        Q <= 1'b1;
    end else begin
        // Toggle when j==1 && k==1
        Q <= ~Q;
    end
end

endmodule
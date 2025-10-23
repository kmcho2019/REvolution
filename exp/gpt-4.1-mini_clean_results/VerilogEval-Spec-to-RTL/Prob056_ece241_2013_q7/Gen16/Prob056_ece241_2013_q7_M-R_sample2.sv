module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        Q <= Q;           // No change
    end else if (j == 0 && k == 1) begin
        Q <= 1'b0;        // Reset
    end else if (j == 1 && k == 0) begin
        Q <= 1'b1;        // Set
    end else begin        // j == 1 && k == 1
        Q <= ~Q;          // Toggle
    end
end

endmodule
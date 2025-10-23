module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        Q <= Q;           // Hold current state
    end else if (j == 0 && k == 1) begin
        Q <= 0;           // Reset
    end else if (j == 1 && k == 0) begin
        Q <= 1;           // Set
    end else begin
        Q <= ~Q;          // Toggle when j==1 && k==1
    end
end

endmodule
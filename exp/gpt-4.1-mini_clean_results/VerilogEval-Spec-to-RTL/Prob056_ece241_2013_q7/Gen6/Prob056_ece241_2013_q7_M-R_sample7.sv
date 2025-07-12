module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0)
        Q <= Q;          // Hold
    else if (j == 0 && k == 1)
        Q <= 1'b0;       // Reset
    else if (j == 1 && k == 0)
        Q <= 1'b1;       // Set
    else // j == 1 && k == 1
        Q <= ~Q;         // Toggle
end

endmodule
module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (!j && !k)
        Q <= Q;         // Hold
    else if (!j && k)
        Q <= 1'b0;      // Reset
    else if (j && !k)
        Q <= 1'b1;      // Set
    else // j && k
        Q <= ~Q;       // Toggle
end

endmodule
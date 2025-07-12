module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

reg next_Q;

always @(*) begin
    if (j == 0 && k == 0)
        next_Q = Q;          // Hold
    else if (j == 0 && k == 1)
        next_Q = 1'b0;       // Reset
    else if (j == 1 && k == 0)
        next_Q = 1'b1;       // Set
    else // j == 1 && k == 1
        next_Q = ~Q;         // Toggle
end

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule
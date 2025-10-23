module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Optional synchronous reset signal: Here omitted per problem statement
// For deterministic startup, we initialize Q to 0 at declaration
initial Q = 1'b0;

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0)
        Q <= Q;          // Hold current state
    else if (j == 1'b0 && k == 1'b1)
        Q <= 1'b0;       // Reset
    else if (j == 1'b1 && k == 1'b0)
        Q <= 1'b1;       // Set
    else // j == 1 && k == 1
        Q <= ~Q;         // Toggle
end

endmodule
module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Explicit initial state to match simulation
);

always @(posedge clk) begin
    q <= a ? 0 : 1; // Simple and direct logic for the sequential behavior
end

endmodule
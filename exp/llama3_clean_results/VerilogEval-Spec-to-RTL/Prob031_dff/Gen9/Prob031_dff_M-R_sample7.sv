module TopModule(
    input clk,
    input d,
    output reg q
);
// Refactored implementation still utilizing the always_ff block for sequential logic
always_ff @(posedge clk) begin
    // Non-blocking assignment to update the value of q at the positive edge of clk
    q <= d;
end

endmodule
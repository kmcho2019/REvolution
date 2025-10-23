module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) q <= 4'd0; // Explicitly specifying the width for clarity
    else if (q == 4'd15) q <= 4'd0; // Explicit wraparound for potential optimization
    else q <= q + 1;
end

endmodule
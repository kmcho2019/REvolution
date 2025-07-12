module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

localparam WIDTH = 4;

// Enable counter increment only when not resetting to reduce switching activity
wire enable = ~reset;

// 4-bit synchronous binary counter with active-high synchronous reset and gating for power optimization
always @(posedge clk) begin
    if (reset)
        q <= {WIDTH{1'b0}};      // Reset counter to 0
    else if (enable)
        q <= q + 1'b1;           // Increment counter by 1 (mod 16)
end

endmodule
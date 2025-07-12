module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

reg [2:0] ptr = 3'b0;  // 3-bit pointer (0-7)

always @(posedge clk) begin
    q[ptr] <= d;       // Insert new bit at current pointer position
    ptr <= ptr + 1;    // Circular increment pointer
end

endmodule
module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        // Efficient detection of 9 (1001) using only 2-bit comparison
        q <= (q[3] & q[0]) ? 4'b0000 : q + 1'b1;
    end
    // Implicit else retains current value (power efficient)
end

endmodule
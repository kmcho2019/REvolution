module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Synchronous reset
    end
    else if (slowena) begin
        // Efficient detection of 9 (1001) and conditional increment
        q <= (q == 4'b1001) ? 4'b0000 : q + 1'b1;
    end
    // Implicit else: maintain current count when slowena is low
end

endmodule
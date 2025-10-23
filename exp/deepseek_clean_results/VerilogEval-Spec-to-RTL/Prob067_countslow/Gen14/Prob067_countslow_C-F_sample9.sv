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
        // Using both detection methods - synthesis will optimize
        q <= (q == 4'b1001 || (q[3] & q[0])) ? 4'b0000 : q + 1'b1;
    end
    // Implicit else maintains q when slowena is low (power optimized)
end

endmodule
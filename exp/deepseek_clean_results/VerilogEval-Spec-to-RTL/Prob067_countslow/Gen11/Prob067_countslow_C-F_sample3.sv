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
        // Using both detection methods for synthesis optimization flexibility
        if (q == 4'b1001 || (q[3] & q[0])) begin  // Detect 9 using both methods
            q <= 4'b0000;
        end
        else begin
            q <= q + 4'b0001;
        end
    end
    // Implicit else maintains q when slowena is low (no power wasted on transitions)
end

endmodule
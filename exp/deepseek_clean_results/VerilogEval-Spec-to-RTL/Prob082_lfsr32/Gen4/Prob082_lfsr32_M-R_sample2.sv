module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // Feedback from LSB

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Tap at bit 32 (q[31])
        q[31] <= q[31] ^ feedback;
        
        // Normal shift for bits 30:22
        q[30:22] <= q[29:21];
        
        // Tap at bit 22 (q[21])
        q[21] <= q[21] ^ feedback;
        
        // Normal shift for bits 20:2
        q[20:2] <= q[19:1];
        
        // Tap at bit 2 (q[1])
        q[1] <= q[1] ^ feedback;
        
        // Tap at bit 1 (q[0]) - just shift in feedback
        q[0] <= feedback;
    end
end

endmodule
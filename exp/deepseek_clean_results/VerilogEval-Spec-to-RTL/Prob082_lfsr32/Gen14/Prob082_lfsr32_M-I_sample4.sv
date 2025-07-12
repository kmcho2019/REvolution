module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // MSB gets q[0]
        q[31] <= q[0];
        
        // Untapped bits (23-30) shift right
        q[30:23] <= q[31:24];
        
        // Tap at bit 22 (position 23)
        q[22] <= q[23] ^ q[0];
        
        // Untapped bits (3-21) shift right
        q[21:3] <= q[22:4];
        
        // Tap at bit 2 (position 3)
        q[2] <= q[3] ^ q[0];
        
        // Tap at bit 1 (position 2)
        q[1] <= q[2] ^ q[0];
        
        // LSB shifts out
        q[0] <= q[1];
    end
end

endmodule
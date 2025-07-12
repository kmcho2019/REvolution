module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Section bits 31:22: shift right
        q[31:22] <= {q[21], q[31:22]};
        
        // Section bits 21:2: shift right and XOR with q[0]
        q[21:2] <= {q[1], q[20:2] ^ {19{q[0]}}};
        
        // Section bits 1:1: shift right and XOR with q[0]
        q[1] <= q[0] ^ q[0];
        
        // LSB bit 0: XOR with q[31], q[21], q[1], and q[0]
        q[0] <= q[31] ^ q[21] ^ q[1] ^ q[0];
    end
end

endmodule
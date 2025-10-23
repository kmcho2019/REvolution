module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] next_q;
integer i;

always @(*) begin
    // Boundary conditions
    next_q[0] = 0 ^ q[1];          // Left boundary (q[-1] = 0)
    next_q[511] = q[510] ^ 0;      // Right boundary (q[512] = 0)
    
    // Main cells
    for (i = 1; i < 511; i = i + 1) begin
        next_q[i] = q[i-1] ^ q[i+1];
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule
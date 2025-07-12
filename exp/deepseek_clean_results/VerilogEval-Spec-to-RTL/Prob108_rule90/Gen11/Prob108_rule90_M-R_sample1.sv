module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Main bits: q[i] = left neighbor ^ right neighbor
            q[510:1] <= q[509:0] ^ q[511:2];
            
            // Boundary conditions:
            // First bit: q[0] = 0 (left neighbor) ^ q[1]
            q[0] <= 1'b0 ^ q[1];
            
            // Last bit: q[511] = q[510] ^ 0 (right neighbor)
            q[511] <= q[510] ^ 1'b0;
        end
    end

endmodule
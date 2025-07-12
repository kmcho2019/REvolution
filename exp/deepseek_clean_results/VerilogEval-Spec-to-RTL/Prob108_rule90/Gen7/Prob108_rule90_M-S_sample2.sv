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
        // Handle first and last cells with boundary conditions
        q[0] <= 0 ^ q[1];          // Left neighbor is 0
        q[511] <= q[510] ^ 0;      // Right neighbor is 0
        
        // Handle middle cells
        for (integer i = 1; i < 511; i = i + 1) begin
            q[i] <= q[i-1] ^ q[i+1];
        end
    end
end

endmodule
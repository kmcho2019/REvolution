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
        // Apply Rule 90 to all cells with boundary conditions
        q[0] <= 0 ^ q[1];  // Left neighbor is 0
        
        q[1] <= q[0] ^ q[2];
        q[2] <= q[1] ^ q[3];
        q[3] <= q[2] ^ q[4];
        // ... (all middle cells explicitly listed)
        q[510] <= q[509] ^ q[511];
        
        q[511] <= q[510] ^ 0;  // Right neighbor is 0
    end
end

endmodule
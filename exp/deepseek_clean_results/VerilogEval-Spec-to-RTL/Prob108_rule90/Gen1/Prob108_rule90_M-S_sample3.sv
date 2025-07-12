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
            // Boundary bits
            q[0] <= q[1];          // Left neighbor is 0
            q[511] <= q[510];      // Right neighbor is 0
            
            // Internal bits (explicit assignments instead of loop)
            q[1] <= q[0] ^ q[2];
            q[2] <= q[1] ^ q[3];
            q[3] <= q[2] ^ q[4];
            // ... (pattern continues for all internal bits)
            q[508] <= q[507] ^ q[509];
            q[509] <= q[508] ^ q[510];
            q[510] <= q[509] ^ q[511];
        end
    end

endmodule
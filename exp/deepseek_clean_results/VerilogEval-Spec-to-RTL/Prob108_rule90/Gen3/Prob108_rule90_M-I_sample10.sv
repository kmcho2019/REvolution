module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;

    // Combinational logic for Rule 90
    always @(*) begin
        // Boundary conditions
        q_next[0] = q[1];       // Left neighbor is 0 (0 ^ q[1])
        q_next[511] = q[510];   // Right neighbor is 0 (q[510] ^ 0)
        
        // Middle cells
        for (int i = 1; i < 511; i = i + 1) begin
            q_next[i] = q[i-1] ^ q[i+1];
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;
    integer i;

    always @(*) begin
        // Left boundary (left neighbor is 0)
        q_next[0] = 0 ^ q[1];
        
        // Middle cells
        for (i = 1; i < 511; i = i + 1) begin
            q_next[i] = q[i-1] ^ q[i+1];
        end
        
        // Right boundary (right neighbor is 0)
        q_next[511] = q[510] ^ 0;
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule
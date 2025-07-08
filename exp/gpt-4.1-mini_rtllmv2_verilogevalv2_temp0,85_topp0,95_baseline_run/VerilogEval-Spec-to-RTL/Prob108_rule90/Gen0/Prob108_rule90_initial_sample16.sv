module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    integer i;
    reg [511:0] q_next;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state using Rule 90
            // Left neighbor of q[0] is zero, right neighbor of q[511] is zero
            q_next[0]     = q[1];
            q_next[511]   = q[510];
            for (i = 1; i < 511; i = i + 1) begin
                q_next[i] = q[i-1] ^ q[i+1];
            end
            q <= q_next;
        end
    end

endmodule
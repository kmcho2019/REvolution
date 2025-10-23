module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state: q[i] = left_neighbor ^ right_neighbor
            // with q[-1] and q[512] treated as 0
            next_state[0] = q[1];
            for (i = 1; i < 511; i = i + 1) begin
                next_state[i] = q[i-1] ^ q[i+1];
            end
            next_state[511] = q[510];
            q <= next_state;
        end
    end
endmodule
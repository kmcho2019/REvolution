module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state using Rule 90:
            // next_state[i] = q[i-1] ^ q[i+1], with q[-1] = 0, q[512] = 0
            next_state[0] = q[1];              // left neighbor = 0, right neighbor = q[1]
            for (i = 1; i < 511; i = i + 1) begin
                next_state[i] = q[i-1] ^ q[i+1];
            end
            next_state[511] = q[510];          // left neighbor = q[510], right neighbor = 0
            q <= next_state;
        end
    end

endmodule
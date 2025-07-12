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
            q <= { 
                q[510:0] ^ q[512-1:1],  // middle bits: XOR neighbors
                1'b0                     // right boundary zero
            };
            // But to correctly do the XOR per bit: next_q[i] = q[i-1] ^ q[i+1], boundaries zero
            // So actually need to build the next state carefully:
            integer i;
            reg [511:0] next_q;
            next_q[0] = q[1];          // left boundary: left neighbor zero, so next_q[0] = 0 ^ q[1] = q[1]
            for (i = 1; i < 511; i = i + 1) begin
                next_q[i] = q[i-1] ^ q[i+1];
            end
            next_q[511] = q[510];      // right boundary: right neighbor zero, so next_q[511] = q[510] ^ 0 = q[510]
            q <= next_q;
        end
    end

endmodule
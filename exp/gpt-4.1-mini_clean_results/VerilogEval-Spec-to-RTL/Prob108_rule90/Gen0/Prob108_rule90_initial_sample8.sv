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
                q[510] ^ 1'b0,               // q[511], left neighbor q[510], right neighbor zero
                q[509:0] ^ q[511:1],         // q[510:1], XOR of neighbors q[i-1] and q[i+1]
                1'b0 ^ q[1]                  // q[0], left neighbor zero, right neighbor q[1]
            };
        end
    end
endmodule
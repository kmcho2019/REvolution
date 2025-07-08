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
            // Compute next state
            // For cell i:
            // q_next[i] = q[i-1] ^ q[i+1]
            // For boundaries: q[-1] = 0, q[512] = 0
            q <= {q[510:0] ^ q[512-:511], 1'b0} ^ {1'b0, q[511:1]};
        end
    end

endmodule
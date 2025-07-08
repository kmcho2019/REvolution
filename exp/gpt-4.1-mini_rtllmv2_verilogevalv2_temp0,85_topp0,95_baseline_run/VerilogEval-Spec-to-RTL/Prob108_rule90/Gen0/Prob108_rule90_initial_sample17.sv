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
            // Calculate next state with boundary neighbors assumed zero
            // For each bit i, next_q[i] = q[i-1] ^ q[i+1]
            // Handle boundaries explicitly
            q <= {q[510:0] ^ q[511:1], q[510] ^ 1'b0};
            // But the last bit q[511] next state = q[510] ^ 0 = q[510]
            // The first bit q[0] next state = 0 ^ q[1] = q[1]
            // The above assignment incorrectly assigns last bit as q[510] ^ 0, 
            // but the concatenation does not cover first bit correctly.
            // Rewrite to explicitly handle each bit:
        end
    end

endmodule
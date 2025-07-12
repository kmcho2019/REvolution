module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [512:0] padded_current;  // zero-padded current state on both ends
    wire [511:0] next_state;

    // Pad the current state with zero on both ends: q[-1] = 0, q[512] = 0
    assign padded_current = {1'b0, q, 1'b0};

    // Compute next state: each bit is XOR of neighbors (left and right)
    assign next_state = padded_current[512:1] ^ padded_current[510:0];

    always @(posedge clk) begin
        if (load) q <= data;
        else      q <= next_state;
    end
endmodule
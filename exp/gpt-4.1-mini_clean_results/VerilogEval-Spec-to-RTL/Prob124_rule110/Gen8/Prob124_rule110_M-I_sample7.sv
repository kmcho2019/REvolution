module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left;   // left neighbors: q shifted left by 1, zero-padded
    wire [511:0] center; // current state (q)
    wire [511:0] right;  // right neighbors: q shifted right by 1, zero-padded

    assign left = {q[510:0], 1'b0};   // Left neighbor of bit i is q[i+1], left shift with zero at LSB
    assign center = q;
    assign right = {1'b0, q[511:1]};  // Right neighbor of bit i is q[i-1], right shift with zero at MSB

    // next_state[i] = (~left[i] & center[i]) | (center[i] ^ right[i]);
    wire [511:0] next_state;
    assign next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
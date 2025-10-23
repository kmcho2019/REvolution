module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Generate neighbors by shifting q with zero padding at boundaries
    wire [511:0] left;   // left neighbor = q shifted left by 1 bit, zero at LSB
    wire [511:0] right;  // right neighbor = q shifted right by 1 bit, zero at MSB
    wire [511:0] center = q;

    assign left  = {q[510:0], 1'b0};  // q[i+1], with q[511+1]=0
    assign right = {1'b0, q[511:1]};  // q[i-1], with q[-1]=0

    // Apply Rule 110 to all bits vectorized:
    // next_state[i] = (~left[i] & center[i]) | (center[i] ^ right[i])
    wire [511:0] next_state;
    assign next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
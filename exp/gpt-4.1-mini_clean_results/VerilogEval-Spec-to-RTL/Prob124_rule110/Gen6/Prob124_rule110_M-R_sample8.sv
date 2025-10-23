module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pad q with zeros on both ends: padded_q = {0, q, 0}
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    // Extract left, center, right neighborhoods as vectors shifted by 2, 1, and 0 bits
    wire [511:0] left   = padded_q[513:2];  // bits i+2
    wire [511:0] center = padded_q[512:1];  // bits i+1
    wire [511:0] right  = padded_q[511:0];  // bits i

    // Apply Rule 110 next state logic vectorized:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
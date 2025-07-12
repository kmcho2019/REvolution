module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended vector with zero padding at both ends
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    // Extract neighbor vectors using shifts on ext_q
    wire [511:0] left   = ext_q[513:2];   // q[i+1]
    wire [511:0] center = ext_q[512:1];   // q[i]
    wire [511:0] right  = ext_q[511:0];   // q[i-1]

    // Rule 110 next state calculation vectorized:
    // next_q[i] = (~left[i] & center[i]) | (center[i] ^ right[i])
    wire [511:0] next_q = ((~left) & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
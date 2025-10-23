module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended 514-bit vector with zero padding on both ends:
    // ext_q = {0, q, 0}
    wire [513:0] ext_q;

    assign ext_q = {1'b0, q, 1'b0};

    // Extract left, center, right neighbor vectors by slicing ext_q:
    // Left neighbors: ext_q[513:2] (bits shifted right by 1)
    // Center: ext_q[512:1]
    // Right neighbors: ext_q[511:0] (shifted left by 1)
    wire [511:0] left  = ext_q[513:2];
    wire [511:0] center= ext_q[512:1];
    wire [511:0] right = ext_q[511:0];

    // Compute next state using Rule 110 formula:
    // next[i] = (~left[i] & center[i]) | (center[i] ^ right[i])
    wire [511:0] next_state;
    assign next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule
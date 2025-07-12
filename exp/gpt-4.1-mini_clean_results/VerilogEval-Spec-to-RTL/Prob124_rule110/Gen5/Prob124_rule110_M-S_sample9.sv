module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pad q with zero boundaries on both ends
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    // Extract neighborhood vectors:
    // left   = padded_q[513:2]
    // center = padded_q[512:1]
    // right  = padded_q[511:0]
    wire [511:0] left   = padded_q[513:2];
    wire [511:0] center = padded_q[512:1];
    wire [511:0] right  = padded_q[511:0];

    // Rule 110 logic vectorized:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
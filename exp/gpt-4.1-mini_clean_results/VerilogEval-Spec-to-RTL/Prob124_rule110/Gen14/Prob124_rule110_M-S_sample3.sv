module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Zero-padded neighbors by concatenation
    wire [511:0] left   = {q[510:0], 1'b0};
    wire [511:0] center = q;
    wire [511:0] right  = {1'b0, q[511:1]};

    // Apply Rule 110 next state: (~left & center) | (center ^ right)
    wire [511:0] next_state = (~left & center) | (center ^ right);

    // Synchronous load or update
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
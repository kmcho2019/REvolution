module TopModule (
    input          clk,
    input          load,
    input  [511:0] data,
    output reg [511:0] q
);

    // Construct left, center, right vectors for next state calculation
    wire [511:0] left;
    wire [511:0] center = q;
    wire [511:0] right;

    // Boundaries zero-padded:
    // left[i] = q[i+1] except left[511]=0
    assign left = {q[510:0], 1'b0};
    // right[i] = q[i-1] except right[0]=0
    assign right = {1'b0, q[511:1]};

    // next_q computed for all 512 bits at once
    wire [511:0] next_q = ((~left) & center) | (center ^ right);

    // Enable update only when loading or state changes to save power
    wire update_enable = load | (next_q != q);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (update_enable)
            q <= next_q;
    end

endmodule
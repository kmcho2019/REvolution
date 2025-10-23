module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            wire left, center, right;

            // Boundary handling:
            // left neighbor: q[i+1] if i < 511, else 0
            assign left = (i < 511) ? q[i+1] : 1'b0;

            // center cell: q[i]
            assign center = q[i];

            // right neighbor: q[i-1] if i > 0, else 0
            assign right = (i > 0) ? q[i-1] : 1'b0;

            // Rule 110 next state logic:
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Sequential process: synchronous load or state update on posedge clk
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state;
    integer i;

    // Combinational block to compute next state according to Rule 110
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Get neighbors with boundary zero-padding
            // left neighbor: q[i+1] or 0 if i == 511
            // center: q[i]
            // right neighbor: q[i-1] or 0 if i == 0
            wire left = (i < 511) ? q[i+1] : 1'b0;
            wire center = q[i];
            wire right = (i > 0) ? q[i-1] : 1'b0;

            // Rule 110 next state logic
            // next_state = (~left & center) | (center ^ right);
            // Use intermediate wires cannot be declared inside procedural block, so replicate logic inline
            next_state[i] = (~left & center) | (center ^ right);
        end
    end

    // Sequential block to update state
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
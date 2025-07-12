module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left;
    wire [511:0] right;
    wire [511:0] next_state;

    // Boundaries are zero, so pad shifted q vectors with zeros at edges
    assign left  = {q[510:0], 1'b0};    // shifted left by 1, q[511] becomes left[510], left[511]=0
    assign right = {1'b0, q[511:1]};    // shifted right by 1, q[0] becomes right[1], right[0]=0

    // Rule 110 next state for all bits vectorized
    assign next_state = (~left & q) | (q ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
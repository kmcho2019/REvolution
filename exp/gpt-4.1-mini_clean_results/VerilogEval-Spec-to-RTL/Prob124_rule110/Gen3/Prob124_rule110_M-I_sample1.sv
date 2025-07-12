module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left, center, right;
    wire [511:0] next_state;

    // Define neighbors using vector shifts and zero padding for boundaries
    assign left   = {q[510:0], 1'b0};     // left neighbor shifted left, boundary zero
    assign center = q;
    assign right  = {1'b0, q[511:1]};     // right neighbor shifted right, boundary zero

    // Apply vectorized boolean formula for Rule 110
    assign next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
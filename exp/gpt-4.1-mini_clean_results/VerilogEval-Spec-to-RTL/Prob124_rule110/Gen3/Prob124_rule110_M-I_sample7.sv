module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    // Pad with zeros by shifting q left and right for neighbors
    wire [511:0] left_neighbor  = {q[510:0], 1'b0};
    wire [511:0] right_neighbor = {1'b0, q[511:1]};
    wire [511:0] center        = q;

    // Compute next state in one vectorized expression:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_state = ((~left_neighbor) & center) | (center ^ right_neighbor);

    // Clock enable signal to reduce toggling: only update q when load=1 or advancing state
    wire enable = load | 1'b1; // Always enable for state update (can optimize to always enable for simplicity)

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule
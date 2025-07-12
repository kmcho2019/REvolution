module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    // Pad q on both ends with zero for boundary conditions
    wire [511:0] state = q;
    wire [511:0] left_shift, right_shift;
    
    // Left neighbor: q shifted left by 1, right boundary zero
    assign left_shift = {state[510:0], 1'b0};
    // Right neighbor: q shifted right by 1, left boundary zero
    assign right_shift = {1'b0, state[511:1]};
    
    // Apply Rule 110 next state:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_state = ((~left_shift) & state) | (state ^ right_shift);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
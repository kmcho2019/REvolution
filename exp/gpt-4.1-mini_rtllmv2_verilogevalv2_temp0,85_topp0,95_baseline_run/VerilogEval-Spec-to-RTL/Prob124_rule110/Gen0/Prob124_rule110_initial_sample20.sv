module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Next state logic
    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] center;

    assign center = q;
    // Left neighbor: q[i+1], with q[512] = 0 at boundary
    assign left_shifted = {q[510:0], 1'b0};
    // Right neighbor: q[i-1], with q[-1] = 0 at boundary
    assign right_shifted = {1'b0, q[511:1]};

    // According to Rule 110:
    // next = (left & center & right)' & 
    //        ((left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right));
    // Or, directly from rule: next = (left & center & ~right) | (left & ~center & right) | (~left & center) | (~left & ~center & right);

    wire [511:0] next_state;

    assign next_state = 
          (left_shifted & center & ~right_shifted) |
          (left_shifted & ~center & right_shifted) |
          (~left_shifted & center) |
          (~left_shifted & ~center & right_shifted);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
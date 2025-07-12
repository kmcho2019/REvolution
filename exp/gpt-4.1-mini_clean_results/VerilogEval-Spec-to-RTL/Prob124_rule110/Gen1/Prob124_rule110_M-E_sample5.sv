module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Compute neighbor vectors:
    // left  = q shifted left by 1, LSB zero padded
    // right = q shifted right by 1, MSB zero padded
    // center = q

    wire [511:0] left, center, right;
    assign left   = {q[510:0], 1'b0};   // q shifted left, zero in LSB
    assign right  = {1'b0, q[511:1]};   // q shifted right, zero in MSB
    assign center = q;

    // Rule 110 next state logic:
    // next = (left & center & ~right) |
    //        (left & ~center & right) |
    //        (~left & center & right) |
    //        (~left & center & ~right) |
    //        (~left & ~center & right);

    wire [511:0] next_state;
    assign next_state =
           (left & center & (~right))   // 110 -> 1
        |  (left & (~center) & right)   // 101 -> 1
        |  ((~left) & center & right)   // 011 -> 1
        |  ((~left) & center & (~right))// 010 -> 1
        |  ((~left) & (~center) & right);//001 -> 1

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule
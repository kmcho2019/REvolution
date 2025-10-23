module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    wire [99:0] rotated_left;
    wire [99:0] rotated_right;
    wire [99:0] next_q;

    // Rotate left by one bit: bits [98:0] shift left, MSB wraps around
    assign rotated_left  = {q[98:0], q[99]};
    // Rotate right by one bit: bits [99:1] shift right, LSB wraps around
    assign rotated_right = {q[0], q[99:1]};

    // Select next state based on load and ena signals
    assign next_q = load       ? data        :
                    (ena == 2'b10) ? rotated_left  :
                    (ena == 2'b01) ? rotated_right :
                    q; // hold current value when no rotation

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule
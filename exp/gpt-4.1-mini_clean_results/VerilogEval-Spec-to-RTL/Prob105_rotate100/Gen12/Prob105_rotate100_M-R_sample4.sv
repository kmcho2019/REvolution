module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire [99:0] rotate_left;
    wire [99:0] rotate_right;
    wire [99:0] next_q;

    // Rotate left by 1 bit: bits [98:0] shifted left + bit [99] rotated to bit 0
    assign rotate_left = {q[98:0], q[99]};
    // Rotate right by 1 bit: bit 0 rotated to bit 99 + bits [99:1] shifted right
    assign rotate_right = {q[0], q[99:1]};

    // Select next_q based on load and ena signals
    assign next_q = load ? data :
                    (ena == 2'b01) ? rotate_right :
                    (ena == 2'b10) ? rotate_left :
                    q;

    // Synchronous process updating q at positive clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire [99:0] rotate_left  = {q[98:0], q[99]};
    wire [99:0] rotate_right = {q[0], q[99:1]};
    wire [99:0] no_rotate    = q;

    wire [99:0] rotate_sel = (ena == 2'b01) ? rotate_right :
                            (ena == 2'b10) ? rotate_left  :
                                             no_rotate;

    wire [99:0] next_q = load ? data : rotate_sel;

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule
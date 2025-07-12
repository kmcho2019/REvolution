module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output reg [99:0] q
);

    wire rotate_left  = (ena == 2'b10);
    wire rotate_right = (ena == 2'b01);

    wire [99:0] rotate_left_data  = {q[98:0], q[99]};
    wire [99:0] rotate_right_data = {q[0], q[99:1]};

    wire [99:0] q_next = load ? data :
                        rotate_left ? rotate_left_data :
                        rotate_right ? rotate_right_data :
                        q;

    always @(posedge clk) begin
        q <= q_next;
    end

endmodule
module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    wire [99:0] rotate_left  = {q[98:0], q[99]};
    wire [99:0] rotate_right = {q[0], q[99:1]};
    wire [99:0] next_q;

    assign next_q = load       ? data       :
                    (ena == 2'b10) ? rotate_left  :
                    (ena == 2'b01) ? rotate_right :
                                     q;

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule
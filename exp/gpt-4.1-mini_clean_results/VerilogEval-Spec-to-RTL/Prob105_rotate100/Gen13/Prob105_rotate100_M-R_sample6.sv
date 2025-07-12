module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Combinational logic to compute next_q based on load and rotation enable
    wire [99:0] rotated_left  = {q[98:0], q[99]};
    wire [99:0] rotated_right = {q[0], q[99:1]};
    wire [99:0] next_q = load      ? data           :   // synchronous load has priority
                        (ena == 2'b01) ? rotated_right :   // rotate right
                        (ena == 2'b10) ? rotated_left  :   // rotate left
                                         q;              // hold

    // Sequential logic: update q on rising edge of clk
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule
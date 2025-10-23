module TopModule (
    input        clk,
    input        load,
    input  [1:0] ena,
    input  [99:0] data,
    output reg [99:0] q
);

    wire [99:0] rotate_left;
    wire [99:0] rotate_right;
    wire [99:0] next_q;

    // Compute rotate left by 1
    assign rotate_left = {q[98:0], q[99]};

    // Compute rotate right by 1
    assign rotate_right = {q[0], q[99:1]};

    // Select next_q based on load and ena
    assign next_q = load       ? data          :
                    (ena == 2'b01) ? rotate_right  :
                    (ena == 2'b10) ? rotate_left   :
                                     q;

    // Sequential update of q on rising edge of clk
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule
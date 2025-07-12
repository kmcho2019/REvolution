module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Precompute rotated versions
    wire [99:0] rotate_left  = {q[98:0], q[99]};
    wire [99:0] rotate_right = {q[0], q[99:1]};

    // Select the next value to load into q
    wire [99:0] next_value;
    assign next_value = load        ? data        :
                        (ena == 2'b10) ? rotate_left :
                        (ena == 2'b01) ? rotate_right :
                                         q;

    // Synchronous update
    always @(posedge clk) begin
        q <= next_value;
    end

endmodule
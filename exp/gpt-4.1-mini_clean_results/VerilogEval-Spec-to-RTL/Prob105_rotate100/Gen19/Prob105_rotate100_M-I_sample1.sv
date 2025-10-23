module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire rotate_left = (ena == 2'b10);
    wire rotate_right = (ena == 2'b01);
    wire reg_enable = load | rotate_left | rotate_right;

    reg [99:0] next_q;

    always @* begin
        if (load) begin
            next_q = data;
        end else if (rotate_left) begin
            // Rotate left by 1: q[98:0] shifted left, q[99] wraps to LSB
            // Using bit-wise indexing to reduce large concatenations
            next_q = {q[98:0], q[99]};
        end else if (rotate_right) begin
            // Rotate right by 1: q[99:1] shifted right, q[0] wraps to MSB
            next_q = {q[0], q[99:1]};
        end else begin
            next_q = q; // Hold current
        end
    end

    // Register update with clock gating to reduce toggling when idle
    always @(posedge clk) begin
        if (reg_enable) begin
            q <= next_q;
        end
    end

endmodule
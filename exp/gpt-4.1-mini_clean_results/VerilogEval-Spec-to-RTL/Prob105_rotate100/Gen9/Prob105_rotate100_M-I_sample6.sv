module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire rotate_right = (ena == 2'b01);
    wire rotate_left  = (ena == 2'b10);
    wire rotate_en    = rotate_right | rotate_left;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (rotate_right) begin
            // Rotate right by 1 bit: q = {q[0], q[99:1]}
            q <= {q[0], q[99:1]};
        end else if (rotate_left) begin
            // Rotate left by 1 bit: q = {q[98:0], q[99]}
            q <= {q[98:0], q[99]};
        end else begin
            // Hold current value (no explicit assignment to allow clock gating)
            q <= q;
        end
    end

endmodule
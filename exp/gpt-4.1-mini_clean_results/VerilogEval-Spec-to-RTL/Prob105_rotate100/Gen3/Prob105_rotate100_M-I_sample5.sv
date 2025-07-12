module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output reg [99:0] q
);

    // Internal signals to control rotation enable
    wire rotate_right  = (ena == 2'b01) && !load;
    wire rotate_left   = (ena == 2'b10) && !load;
    wire rotate_enable = rotate_right || rotate_left;

    always @(posedge clk) begin
        if (load) begin
            // Priority to synchronous load
            q <= data;
        end else if (rotate_enable) begin
            if (rotate_right) begin
                // Rotate right by one: LSB becomes MSB
                q <= {q[0], q[99:1]};
            end else if (rotate_left) begin
                // Rotate left by one: MSB becomes LSB
                q <= {q[98:0], q[99]};
            end
        end
        // else retain q unchanged to minimize toggling
    end

endmodule
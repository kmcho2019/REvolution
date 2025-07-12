module TopModule (
    input        clk,
    input        load,
    input  [1:0] ena,
    input  [99:0] data,
    output reg [99:0] q
);

    // Determine rotation direction
    wire rotate_right = (ena == 2'b01);
    wire rotate_left  = (ena == 2'b10);
    // Enable updating q only when load or rotation requested
    wire en_update = load | rotate_left | rotate_right;

    always @(posedge clk) begin
        if (load) begin
            // Synchronous load of input data
            q <= data;
        end else if (rotate_right) begin
            // Rotate right by one bit: LSB moves to MSB position
            q <= {q[0], q[99:1]};
        end else if (rotate_left) begin
            // Rotate left by one bit: MSB moves to LSB position
            q <= {q[98:0], q[99]};
        end
        // No assignment when en_update is low (holds q without toggling)
    end

endmodule
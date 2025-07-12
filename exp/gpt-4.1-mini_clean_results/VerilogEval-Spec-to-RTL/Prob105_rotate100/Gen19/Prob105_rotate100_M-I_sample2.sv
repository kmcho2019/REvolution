module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Decode ena to one-hot enables for rotation directions
    wire rotate_left  = (ena == 2'b10);
    wire rotate_right = (ena == 2'b01);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (rotate_left) begin
            // Rotate left by one bit: MSB shifted out goes to LSB
            q <= {q[98:0], q[99]};
        end else if (rotate_right) begin
            // Rotate right by one bit: LSB shifted out goes to MSB
            q <= {q[0], q[99:1]};
        end else begin
            // Hold current value (ena==00 or ena==11)
            q <= q;
        end
    end

endmodule
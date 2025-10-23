module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            // Synchronously load input data
            q <= data;
        end else if (ena == 2'b10) begin
            // Rotate left by one bit: MSB wraps around to LSB
            q <= {q[98:0], q[99]};
        end else if (ena == 2'b01) begin
            // Rotate right by one bit: LSB wraps around to MSB
            q <= {q[0], q[99:1]};
        end else begin
            // No rotation or load: hold current value to minimize toggling
            q <= q;
        end
    end

endmodule
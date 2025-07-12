module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-calculate the rotated values
wire [99:0] rotate_right = {q[0], q[99:1]};
wire [99:0] rotate_left = {q[98:0], q[99]};

// Use assign statements to select the output based on the ena signal
always @(posedge clk) begin
    if (load) begin
        // Load the shift register with data
        q <= data;
    end else begin
        case (ena)
            2'b01: q <= rotate_right; // Rotate right
            2'b10: q <= rotate_left; // Rotate left
            default: q <= q; // No rotation
        endcase
    end
end

endmodule
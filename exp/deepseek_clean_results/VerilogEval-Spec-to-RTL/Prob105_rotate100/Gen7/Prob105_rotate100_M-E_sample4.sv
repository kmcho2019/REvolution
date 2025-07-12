module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-decode rotation control
wire rotate_en = (ena == 2'b01) | (ena == 2'b10);
wire rotate_dir = (ena == 2'b10); // 1 for left, 0 for right

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (rotate_en) begin
        if (rotate_dir) begin
            // Left rotate: MSB becomes LSB, others shift left
            q <= {q[98:0], q[99]};
        end
        else begin
            // Right rotate: LSB becomes MSB, others shift right
            q <= {q[0], q[99:1]};
        end
    end
    // else hold value (implicit)
end

endmodule